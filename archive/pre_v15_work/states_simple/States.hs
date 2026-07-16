-- =============================================================================
-- States.hs  --  Where unit state lives, built one idea at a time.
--
-- This file is a thread, in the manner of Hutton's "Programming in Haskell":
-- the simplest version of an idea first, then evolved in small steps, each step
-- shown evaluating in GHCi (a line beginning `>` is what you type; the line
-- under it is what GHCi prints) and explained in plain English before the next
-- step is taken. Types come before functions; functions are built from simpler
-- functions; an abstraction (a monoid, a fold) is named only once we have
-- already written the thing it is the name of.
--
-- Load it with:  ghci States.hs   (or: runghc States.hs to run `main`).
--
-- The destination, reached at the end and not before, is this: the state of a
-- unit lives in three homes and -- on a reification this file establishes for one
-- mandate and assumes in general -- no fourth; and, because two of the three are
-- keyed by the unit alone, those three homes need only two maps.
-- =============================================================================

module States
  ( -- * Quantities (step 1)
    Qty (..)
  , negQty
    -- * Keys (step 2)
  , WalletId (..)
  , UnitId (..)
    -- * (Steps 3-4 build the balance map and the conserving transfer as teaching
    --   scaffolding. `Balances`, `holding`, `netOf` and `transfer` are
    --   deliberately NOT exported: they are superseded by the sealed `Ledger`,
    --   its `PositionState` map, `applyMove` and `netBal`. Exporting them would
    --   offer a second, unsealed move API able to build a non-conserving balance
    --   map by hand -- the very thing the sealed `Ledger` exists to prevent.)
    -- * Shared status (step 5)
  , Price (..)
  , Lifecycle (..)
  , UnitStatus (..)
  , defaultStatus
  , settlementPrice
    -- * Versioned terms (step 6)
    --   `ProductTerms` is exported WITHOUT its constructor: an importer may read
    --   the current version and append a new one, but cannot lay down a fresh
    --   one-version value and so discard history. The one writer that lays down a
    --   first version, `register`, refuses an already-registered unit, so it too
    --   cannot shorten history. The append-only discipline is then guaranteed by
    --   construction, not by convention.
  , TermsVersion (..)
  , ProductTerms
  , currentTerms
  , appendVersion
    -- * Per-position state (step 7)
  , PositionState (..)
  , zeroP
    -- * The ledger (step 8)
    --   The `Ledger` constructor and its field selectors are deliberately NOT
    --   exported: a `Ledger` can only be built by `emptyLedger`, `register`,
    --   `settle` and `applyMove`. Sealing it is what makes conservation hold by
    --   construction (only `applyMove` writes a balance, and it writes two
    --   cancelling legs) and keeps `register` the sole, append-only door to a
    --   unit's terms. Terms/status co-presence needs no sealing: it is
    --   structural -- the two ride together as a pair under one key (step 8).
  , Ledger
  , emptyLedger
  , register
  , settle
  , productTerms
  , unitStatus
  , position
  , Move (..)
  , applyMove
  , netBal
    -- * Replay (step 9)
  , Event (..)
  , apply
  , replay
    -- * Demo
  , main
  ) where

import           Control.Monad      (foldM)
import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NE
import           Data.Map.Strict    (Map)
import qualified Data.Map.Strict    as Map

-- =============================================================================
-- 1.  The simplest thing that holds a balance.
-- =============================================================================
--
-- A balance is a quantity. We measure it in exact minor units -- whole integers
-- of the smallest denomination (cents, not dollars) -- never in floating point,
-- because two balances must add up to exactly what we expect, with no rounding.

newtype Qty = Qty Integer deriving (Eq, Ord)

instance Show Qty where show (Qty n) = show n

-- A balance of nothing is zero; two balances combine by adding. Once we have
-- said both of those, we have said something with a name: `Qty` is a *monoid* --
-- a type with an identity (`mempty`) and an associative way to combine
-- (`<>`). We write the instances and then use that name from here on.

instance Semigroup Qty where Qty a <> Qty b = Qty (a + b)
instance Monoid    Qty where mempty = Qty 0

-- > Qty 1000 <> Qty (-1000)
-- 0
--
-- > mempty :: Qty
-- 0
--
-- Every balance also has a *negation*: combine `Qty n` with `Qty (-n)` and you
-- land back at the identity. A monoid in which every element has an inverse is a
-- *group*. We give the inverse a name now, because a move in step 4 is built
-- from it: a transfer's two legs must be exact opposites, and this is what makes
-- them so.

negQty :: Qty -> Qty
negQty (Qty n) = Qty (negate n)

-- > Qty 1000 <> negQty (Qty 1000)
-- 0
--
-- We will lean on exactly this -- a pair of legs that combine to the identity --
-- when we state conservation. Nothing more than a group is needed for it.

-- =============================================================================
-- 2.  Whose balance, and of what?  Two keys.
-- =============================================================================
--
-- A balance on its own is anonymous. A balance is held by a *wallet*, and it is
-- a balance of some *unit* -- a thing that can be held: an instrument, but also
-- a mandate or a strategy contract. Two keys, each just a name.

newtype WalletId = WalletId String deriving (Eq, Ord, Show)
newtype UnitId   = UnitId   String deriving (Eq, Ord, Show)

-- =============================================================================
-- 3.  The first map: a balance per (wallet, unit).
-- =============================================================================
--
-- The natural home for a balance is a finite map keyed by the pair (wallet,
-- unit). Two wallets that hold the same unit appear as two separate keys, and so
-- carry two separate balances -- which is exactly right, because two holders of
-- the same contract need not hold the same amount.

type Balances = Map (WalletId, UnitId) Qty

-- To read one holding, look up its key. The map's lookup returns `Maybe`, and
-- that `Maybe` is doing real work, so read it carefully:

holding :: Balances -> WalletId -> UnitId -> Maybe Qty
holding b w u = Map.lookup (w, u) b

-- Set up two holders of one unit.
--
-- > let uES = UnitId "ES"
-- > let wB  = WalletId "BUYER"
-- > let wS  = WalletId "SELLER"
-- > let b   = Map.fromList [((wB,uES), Qty 1000), ((wS,uES), Qty (-1000))]
--
-- > holding b wB uES
-- Just 1000
--
-- > holding b (WalletId "OTHER") uES
-- Nothing
--
-- `Nothing` means this wallet has *never held* this unit -- there is no key for
-- it. Now watch what happens when a holder goes flat:
--
-- > let b2 = Map.insert (wB,uES) (Qty 0) b
-- > holding b2 wB uES
-- Just 0
--
-- `Just 0` is not the same as `Nothing`. It means *held, and now flat* -- the
-- key exists, the balance is zero. The two readings are different facts and we
-- never collapse them: "never traded this" and "traded this and closed it" are
-- answered differently by, for instance, settlement entitlement versus a
-- lookback. The `Maybe` keeps them apart for free. Hold on to this; the held
-- quantity stored here is the *primary* per-position fact, and in step 7 this
-- same value grows from a bare number into a small record -- but the held
-- quantity stays, as that record's first field.

-- =============================================================================
-- 4.  Conservation: a move is a transfer, so it cannot fail to balance.
-- =============================================================================
--
-- Every unit is issued: whatever one wallet is up, the counterparties are down
-- by the same amount. So across all holders of a unit, the balances sum to zero.
-- To state that, we add up the balances of one unit. We already have the tool:
-- `Qty` is a monoid, so "combine all of these" is `foldMap`.

netOf :: Balances -> UnitId -> Qty
netOf b u = foldMap snd [ kv | kv@((_, u'), _) <- Map.toList b, u' == u ]

-- > netOf b uES
-- 0
--
-- The conservation law, in one line of English: for every unit, `netOf b u` is
-- `mempty`. We did not need anything cleverer than the monoid to say it.
--
-- Now make a balance *change* -- and make it so that the law cannot be broken.
-- A move is a *transfer*: a quantity leaves one wallet and arrives at another,
-- in the same unit. The two legs are not free to be anything we like; they are
-- `negQty q` at the source and `q` at the destination, written together, in one
-- function, from one quantity. Because they are exact inverses (step 1), they
-- combine to `mempty`. There is nothing else the type admits: a source, a
-- destination, one quantity. An unbalanced move is not a move we reject -- it is
-- a sentence the language will not let us write.

transfer :: UnitId -> WalletId -> WalletId -> Qty -> Balances -> Balances
transfer u from to q b =
  Map.insertWith (<>) (to,   u) q
    (Map.insertWith (<>) (from, u) (negQty q) b)

-- (read as: q leaves `from`, arrives at `to`)
-- > let b1 = transfer uES wS wB (Qty 1000) Map.empty   -- 1000: SELLER -> BUYER
-- > netOf b1 uES
-- 0
--
-- Conservation is not a thing we test after the fact, and it is not a
-- precondition the caller is trusted to honour: a single quantity moved from a
-- named source to a named destination is balanced because the source leg is the
-- inverse of the destination leg, and the constructor of a transfer cannot
-- separate the two. This is the whole reason `Qty` was built with an identity
-- and an inverse in step 1. `transfer` here works on the bare balance map; in
-- step 8 the very same two-legs-from-one-quantity move is lifted, unchanged in
-- spirit, onto the enriched per-position map.

-- =============================================================================
-- 5.  A shared fact, keyed by the unit alone: status.
-- =============================================================================
--
-- Not every fact about a unit is per holder. The day's settlement price is one
-- number; the contract's lifecycle stage is one stage. Every holder reads the
-- *same* value. If we stored such a value per (wallet, unit), we would keep many
-- copies of one number and invite them to drift apart. So a shared, mutable
-- value is keyed by the unit alone -- no wallet in the key. (The home it shares
-- with terms is assembled in step 8.)

-- A settlement price is a number too -- but it is *not* a quantity, and the type
-- must say so. You never add two settlement prices, and you never move a price
-- from one wallet to another; a price has neither the identity nor the inverse
-- that conservation leans on. So, unlike `Qty` (step 1), `Price` is deliberately
-- *not* a monoid and *not* a group: giving it its own newtype keeps a price from
-- ever being summed into a balance, or a balance mistaken for a price. They share
-- one `Integer` underneath and nothing else, and that "nothing else" is the whole
-- point -- the only type that carries the group structure is the one that conserves.

newtype Price = Price Integer deriving (Eq, Show)

-- A unit's lifecycle has more stages in the full system (expiry, close-out); this
-- file carries only the two its writers actually reach -- `Unsettled`, set at
-- registration, and `Active`, set once the unit settles. And the settlement price
-- is not a fact that floats free of the stage: a unit *has* a settlement price
-- exactly when it has settled, which is exactly when it is `Active`. So the price
-- rides *on* the `Active` constructor -- it is data the stage carries, present
-- precisely in the one stage that has it.
data Lifecycle = Unsettled | Active Price deriving (Eq, Show)

-- The shared status of a unit is, in this file, exactly its lifecycle stage. (In
-- the full system status also carries other shared-mutable facts read identically
-- by every holder -- current weights, the benchmark level; here the one such fact
-- is the stage, which now carries the price.) It keeps its own name because it is
-- the shared-status *home* of step 8, keyed by the unit alone.

newtype UnitStatus = UnitStatus { usLifecycle :: Lifecycle } deriving (Eq, Show)

-- A freshly registered unit has a known default: unsettled, and -- by the shape of
-- `Unsettled`, which carries nothing -- no settlement price.

defaultStatus :: UnitStatus
defaultStatus = UnitStatus Unsettled

-- The price rides on the `Active` constructor, not in a field beside the stage,
-- and that placement is what makes "priced exactly when active" hold by
-- construction: there is no second field that could carry a price while the stage
-- says `Unsettled`, and no `Active` that could lack one. Both illegal states --
-- active-but-unpriced, unsettled-but-priced -- are unspellable, not held out by a
-- writer keeping two fields in lockstep.
--
-- This is the *opposite* case from conservation (step 4): conservation stays a
-- writer invariant only because a `Map` cannot cheaply carry "sums to zero," so we
-- disclose it honestly as one; here the type *can* carry the correlation for free,
-- so we make the illegal state unrepresentable instead. The rule is the same in
-- both places -- prefer the shape; the difference is only whether the shape can
-- afford it.

-- Reading the settlement price is total and says exactly what is true: an `Unsettled`
-- unit has none, an `Active` one has the price its stage carries. The `Maybe` here
-- is not a hole the type leaves open -- it is the two reachable cases, "not yet
-- settled" and "settled, price present," and nothing else.

settlementPrice :: UnitStatus -> Maybe Price
settlementPrice (UnitStatus Unsettled)   = Nothing
settlementPrice (UnitStatus (Active px)) = Just px

-- This value is *overwritten* in place each time the unit settles: the writer
-- that does it is `settle` in step 8, and the stored status keeps no prior price
-- -- each settle replaces it. Note that change discipline now; it is the contrast
-- that, in step 6, forces terms into a home of their own. The accessor (step 8) takes a
-- unit and no wallet, which is the type making the point: there is one status for
-- the contract as a whole, read identically by all holders.

-- =============================================================================
-- 6.  A second unit-keyed fact, with a different change discipline: terms.
-- =============================================================================
--
-- Terms and status differ in *how they change*, and that difference forces them
-- apart. Status is overwritten on each settle: the stored value is the current
-- stage and nothing earlier (step 5). Terms are never rewritten in place; a
-- correction is *appended* as a new version and the prior versions are kept --
-- they are externally authored (the multiplier, currency, expiry and fee schedule
-- are owned by the exchange, the contract, the reference-data provider, which the
-- ledger consumes and never creates), so a correction preserves the authority's
-- prior version rather than discarding it.
--
-- Two such disciplines cannot share one value: a single value would have to be an
-- append-only record and an overwrite-in-place cell at once. So terms and status
-- are distinct values with distinct types -- a non-empty version list grown by
-- `appendVersion` (here) and a single value replaced by `settle` (step 8). They
-- are nonetheless *both keyed by the unit*, so they need not be two maps: in step
-- 8 they ride together as a pair under one unit key, each half keeping its own
-- discipline. "Third home" here means a third kind of state, not a third map.
--
-- "One or more versions, append-only" has a type that says exactly that: a
-- non-empty list. Non-empty, because a registered unit always has at least its
-- first version -- "registered but versionless" is not representable.

data TermsVersion = TermsVersion
  { tvLabel :: String                -- stands in for multiplier, ISIN, expiry, ...
  } deriving (Eq, Show)

newtype ProductTerms = ProductTerms (NonEmpty TermsVersion) deriving (Eq, Show)

-- The version in force is the most recently appended one. Because the list is
-- non-empty, this is total -- no `Maybe`, there is always a current version.

currentTerms :: ProductTerms -> TermsVersion
currentTerms (ProductTerms vs) = NE.last vs

-- The only way terms grow is by appending. There is deliberately no function
-- that rewrites a version in place, and -- because the constructor is not
-- exported (see the module header) -- no importer can build a fresh
-- one-version value either. Three doors in this module touch `ProductTerms`, and
-- none can shorten history: `register` (step 8) lays down version one, but only
-- for a unit not yet present -- it refuses an already-registered unit, so it can
-- only ever create history where there was none; `appendVersion` (here) grows;
-- `currentTerms` (here) reads. Write-where-there-was-nothing, grow, read: the
-- append-only discipline is enforced by construction, not by the convention
-- "never register twice".

appendVersion :: TermsVersion -> ProductTerms -> ProductTerms
appendVersion tv (ProductTerms vs) = ProductTerms (vs <> (tv :| []))

-- > let pt = ProductTerms (TermsVersion "ES-v1" :| [])
-- > currentTerms pt
-- TermsVersion {tvLabel = "ES-v1"}
--
-- > currentTerms (appendVersion (TermsVersion "ES-v2") pt)
-- TermsVersion {tvLabel = "ES-v2"}
--
-- The first version is still in the list; the amendment did not erase it. The
-- accessor just reports the latest. Set this beside `settle`, which throws the
-- old value away: the two disciplines visibly differ, and that difference is the
-- reason this is a third home and not a second.

-- =============================================================================
-- 7.  The per-position value grows up.
-- =============================================================================
--
-- A balance was enough to start, but a real position carries more than the one
-- number. The held quantity from step 3 stays -- it is the primary fact, and it
-- conserves (sums to zero over holders, step 4) -- but it is now joined by a
-- high-water mark, which does *not* conserve: it ratchets up and is kept for tax
-- reporting even after the position closes. So the value at a (wallet, unit) key
-- is no longer a bare `Qty` but a small record whose first field is exactly the
-- step-3 balance.

data PositionState = PositionState
  { psBal :: Qty          -- held quantity: the primary fact; conserved, sums to zero
  , psHwm :: Qty          -- high-water mark: not conserved, retained on close-out
  } deriving (Eq, Show)

-- The row a position starts life as, on first touch -- every field at the
-- monoid's zero. The held quantity is then moved by the transfer of step 4
-- (lifted in step 8); the high-water mark is set by a valuation event, which is
-- out of scope for this file -- here it stays at its zero, and its role is
-- purely to show a non-conserved field riding alongside the conserved balance.

zeroP :: PositionState
zeroP = PositionState mempty mempty

-- The `Maybe` distinction from step 3 survives the upgrade unchanged, and now it
-- earns even more: `Nothing` is still "never held", and `Just zeroP` is still
-- "held and flat" -- but a flat row may also carry a retained high-water mark,
-- so "flat" and "the zero row" are not quite the same, and neither is "never
-- held". Three readings, all distinct, none collapsed.

-- =============================================================================
-- 8.  The homes together: the ledger -- three homes, two maps.
-- =============================================================================
--
-- Now assemble the three homes into one value. Two of them -- versioned terms and
-- shared status -- are keyed by the unit alone (steps 5-6); the third,
-- per-position state, is keyed by (wallet, unit), and that map *is* the balance
-- map of step 3 enriched, its value carrying the held quantity in `psBal`.
--
-- Two homes, one key. Terms and status are both keyed by the unit alone, so they
-- ride together as one map whose value is a pair:
-- `Map UnitId (ProductTerms, UnitStatus)`. Co-presence is then the shape itself,
-- not a writer invariant -- there is no "in terms but not status" value to hold
-- out, because one entry carries both halves or neither. This is the same rule
-- step 5 used on the price: prefer the shape that makes the illegal state
-- unspellable; disclose an invariant only when the shape cannot carry it. Here it
-- can, cheaply, so we take it. The two halves keep their separate disciplines --
-- `fst` append-only (a `NonEmpty` grown by `appendVersion`), `snd` overwritten (a
-- single value replaced by `settle`) -- so housing them in one map costs nothing
-- the "third home, not second" argument (step 6) relied on.
--
-- Is there a *fourth* home -- a sector of per-wallet economic state, keyed by the
-- wallet and no unit? The claim that there is not rests on a reification: every
-- per-wallet economic fact is a fact about the holder's relationship to some
-- *unit*, and that relationship is itself a unit the holder holds. A managed
-- account's high-water mark, its entry NAV, its accrued fee are then facts about
-- the holder's position in a *mandate unit*, already living in the per-position
-- map keyed by (wallet, mandate) -- no fourth map. This file establishes the
-- reification only for the single-mandate case (n = 1: one holder, one mandate
-- unit); that a *multi-instrument* relationship is likewise a single unit is
-- assumed here, not proved. So "no fourth home" is stated honestly as
-- *conditional on that reification*: given that every wallet-economic fact reifies
-- as a position in some unit, three homes suffice and no fourth is forced.
-- Whatever stays genuinely wallet-keyed -- KYC, permissions, an audit cursor --
-- is identity, not economic state, and is outside the three either way. Three
-- homes, two maps, and -- on that reification -- no fourth.

data Ledger = Ledger
  { ledgerUnit :: Map UnitId (ProductTerms, UnitStatus)  -- unit-keyed: terms (append-only) beside status (overwrite); co-present by shape
  , ledgerPS   :: Map (WalletId, UnitId) PositionState   -- per (holder, unit); holds psBal
  } deriving (Eq, Show)

-- The `Ledger` constructor and its two field selectors are *not* exported (see
-- the module header). The seal no longer carries the terms/status coherence --
-- the pair carries that for free -- so it is left to do the one job only it can:
-- keep conservation true by construction. `applyMove` is the sole writer of a
-- balance and it writes two cancelling legs (step 4), and `register` is the sole,
-- append-only door to a unit's terms; with the constructor hidden, no outside
-- code can lay down a non-conserving position map, or a shortened terms history,
-- by hand. (The full conservation argument is on `applyMove` below.)

emptyLedger :: Ledger
emptyLedger = Ledger Map.empty Map.empty

-- A unit enters the ledger by registration, which writes one map entry: the pair
-- of its first terms version and its default status. Because terms and status are
-- the two halves of a single entry, they enter together and leave together by the
-- shape of the map -- there is nothing left to keep "in step". Registration
-- *refuses a unit it already knows*: it returns `Maybe`, and `Nothing` when the
-- unit is already registered. That refusal is what keeps `register` from being a
-- door that shortens history -- it never overwrites an existing entry, so the
-- append-only discipline of step 6 holds by construction and not by the
-- convention "never register twice". (Same shape as the other two writers below:
-- a writer that names an out-of-bounds unit -- here, an *already-present* one --
-- is refused, not silently absorbed.)

register :: UnitId -> TermsVersion -> Ledger -> Maybe Ledger
register u tv l
  | Map.member u (ledgerUnit l) = Nothing
  | otherwise = Just (l
      { ledgerUnit =
          Map.insert u (ProductTerms (tv :| []), defaultStatus) (ledgerUnit l) })

-- Settle a unit: overwrite its status with the `Active` stage carrying the day's
-- price. It touches only the *status* half of the entry -- `Map.adjust` over the
-- pair's `snd`, leaving the terms half exactly where it was. This is the overwrite
-- writer promised in steps 5-6 -- it *discards* the prior status, in deliberate
-- contrast to `appendVersion`, which keeps every prior term; the two disciplines
-- sit side by side in one entry and never touch each other. It returns `Maybe`
-- for the same reason `applyMove` does: a settle that names an unregistered unit
-- is malformed input and is rejected. The one value it can write,
-- `UnitStatus (Active px)`, is `Active`-and-priced -- the only shape settle can
-- produce -- so the "priced iff active" correlation holds by the type of what is
-- written, not by a discipline the writer is trusted to keep.

settle :: UnitId -> Price -> Ledger -> Maybe Ledger
settle u px l
  | Map.member u (ledgerUnit l) =
      Just (l { ledgerUnit =
        Map.adjust (\(t, _) -> (t, UnitStatus (Active px))) u (ledgerUnit l) })
  | otherwise = Nothing

-- The three accessors. Note the shapes: terms and status take a unit; position
-- takes a wallet and a unit. Terms and status read the two halves of the one
-- unit-keyed entry, so each returns `Nothing` exactly when the unit is
-- unregistered -- never one present and the other absent. The `Maybe` on
-- `position` is the load-bearing one from step 3 -- never-held versus
-- held-and-flat.

productTerms :: Ledger -> UnitId -> Maybe ProductTerms
productTerms l u = fst <$> Map.lookup u (ledgerUnit l)

unitStatus :: Ledger -> UnitId -> Maybe UnitStatus
unitStatus l u = snd <$> Map.lookup u (ledgerUnit l)

position :: Ledger -> WalletId -> UnitId -> Maybe PositionState
position l w u = Map.lookup (w, u) (ledgerPS l)

-- A move on the ledger is the transfer of step 4, lifted from bare balances to
-- the held-quantity field `psBal` of a position -- the very same two legs from
-- one quantity. It is *gated on registration*: a position may exist only for a
-- unit that already has terms and a status.

data Move = Move
  { mvUnit :: UnitId
  , mvFrom :: WalletId
  , mvTo   :: WalletId
  , mvQty  :: Qty
  } deriving (Eq, Show)

applyMove :: Move -> Ledger -> Maybe Ledger
applyMove (Move u from to q) l
  | Map.member u (ledgerUnit l) =
      Just (l { ledgerPS = Map.foldrWithKey writeNet (ledgerPS l) (netDeltas from to q) })
  | otherwise = Nothing
  where
    -- A move's effect on the position map is its *per-wallet net delta*, not its
    -- two legs taken one at a time. We compute that net first: the transfer is
    -- the pair (`negQty q` at the source, `q` at the destination), summed *into
    -- one entry per wallet*. For an ordinary move (`from /= to`) this is two
    -- entries, `-q` and `+q`; for a self-move (`from == to`) the two legs land on
    -- the *same* wallet and cancel to `mempty`, exactly as a `Qty 0` move's leg
    -- is already `mempty`. Either way the move sums to `negQty q <> q = mempty`
    -- over wallets, so netting leaves conservation untouched.
    netDeltas :: WalletId -> WalletId -> Qty -> Map WalletId Qty
    netDeltas f t qty =
      Map.insertWith (<>) t qty (Map.insertWith (<>) f (negQty qty) Map.empty)
    -- A zero net delta writes nothing. Adding `mempty` to a held quantity changes
    -- no balance, so the *only* effect a zero delta could have is to create a row
    -- where there was none -- and that would conjure a "held and flat" reading
    -- (step 3) for a wallet that never held a nonzero position. Two well-formed
    -- moves net to zero on a wallet: a move of `Qty 0`, and a self-move
    -- (`from == to`). Both are well-formed input (the unit may be perfectly well
    -- registered), so we do not reject them; but neither may manufacture a phantom
    -- row, because the never-held versus held-and-flat distinction is load-bearing
    -- (settlement entitlement, the wash-sale lookback) and a false "held" would
    -- silently corrupt both. Netting per wallet before writing makes this one rule,
    -- not two: a wallet whose net delta is `mempty` is left untouched, whether the
    -- zero came from a zero quantity or from a self-move's two legs cancelling.
    -- "Held" therefore means *named in a move that nets nonzero on it*, and
    -- nothing weaker.
    writeNet w d ps
      | d == mempty = ps
      | otherwise   =
          let cur = Map.findWithDefault zeroP (w, u) ps   -- first touch -> flat row
          in  Map.insert (w, u) (cur { psBal = psBal cur <> d }) ps

-- The `Maybe` here guards *input*, not the balance, and the two must not be
-- conflated. `applyMove` returns `Nothing` for one reason only: the move names a
-- unit that was never registered -- malformed input, refused, not absorbed.
-- Conservation is a separate matter, and it cannot be broken by a well-formed
-- move at all: the two legs are `negQty q` and `q`, written together from one
-- quantity, so they cancel by construction. So `Nothing` answers "is this unit
-- known?"; it never answers "did the balance hold?" -- a written transfer always
-- conserves.
--
-- Two honest qualifications, so the claim is not overstated. First, the *store*
-- type `Map (WalletId, UnitId) PositionState` can perfectly well hold a
-- non-conserving map -- nothing in that type sums to zero. Conservation is an
-- *invariant of the writer*: `applyMove` is the only function that ever touches
-- `psBal`, and it writes the two cancelling legs together, so each move changes
-- the holding sum by `negQty q <> q`, which is `mempty`. The other two writers,
-- `register` and `settle`, never touch `psBal` at all, so they leave every
-- holding sum exactly where it was. From `emptyLedger` (sum zero) every writer
-- preserves the sum -- the move by cancelling, the other two by not touching it
-- -- so every *reachable* ledger conserves, and the hidden constructor (step 8)
-- is what makes that reach exhaustive: no outside code can lay a non-conserving
-- map down by hand. Conservation is unbreakable not because the type forbids the
-- bad value, but because the only door that writes the balance writes it balanced.
--
-- Second, `psHwm`. It is typed `Qty` here, matching the source, but this file
-- leans on *none* of `Qty`'s group structure for it. What a high-water mark
-- measures -- and so whether two of them compose, and how -- is fixed by its
-- writer, a valuation event out of scope for this file, not decided here. One
-- role is kept for `psHwm`: a non-conserved field riding beside the conserved
-- balance. It has no paired writer -- no move writes it as two cancelling legs --
-- so it carries no zero-sum invariant, and nothing in this file folds it over
-- holders; `netBal` (below) sums `psBal` alone. The load-bearing fact is narrower
-- and exact, and it is about `psBal`, not `psHwm`: per-position state *composes*.
-- Balances add under the `Qty` monoid, the per-position rows combine holder by
-- holder, and conservation is one fold over that composition. Conservation is a
-- property of *how a field is written*: `psBal` cancels because its writer lays
-- down two inverse legs. For `psHwm` this file makes no aggregate claim at all --
-- not that it conserves, not that it measures any peak across holders -- because
-- none is needed here, and its algebra belongs to its out-of-scope writer.
--
-- Conservation, restated for the field that is actually stored: sum the held
-- quantity `psBal` over all holders of a unit. Same `foldMap` over the same
-- monoid as step 4, now over the assembled ledger.

netBal :: Ledger -> UnitId -> Qty
netBal l u = foldMap psBal [ p | ((_, u'), p) <- Map.toList (ledgerPS l), u' == u ]

-- Walk one unit through registration, a settle, a trade, and a close-out.
--
-- > let uES = UnitId "ES"
-- > let wB  = WalletId "BUYER"
-- > let wS  = WalletId "SELLER"
-- > let Just l0 = register uES (TermsVersion "ES-v1") emptyLedger
--
-- Registering the same unit again is refused -- typed `Nothing`, history intact:
--
-- > register uES (TermsVersion "ES-v2") l0
-- Nothing
--
-- Registered but untraded: status is present, no position exists yet.
--
-- > unitStatus l0 uES
-- Just (UnitStatus {usLifecycle = Unsettled})
--
-- > position l0 wB uES
-- Nothing
--
-- A move into a unit that was never registered is refused -- typed `Nothing`,
-- no position conjured:
--
-- > applyMove (Move (UnitId "X") wB wS (Qty 1)) l0
-- Nothing
--
-- A zero-quantity move is *well-formed* -- its unit is registered -- so it is
-- not refused; but it moves nothing, so it conjures no row. A wallet named only
-- in a zero move is still never-held, not held-and-flat:
--
-- > let Just l0z = applyMove (Move uES wB wS (Qty 0)) l0
-- > position l0z wB uES
-- Nothing
-- > position l0z wS uES
-- Nothing
--
-- A self-move (from == to) is well-formed too, and nonzero -- but its two legs
-- land on one wallet and net to zero, so it likewise conjures no row. A wallet
-- named only as both ends of a move is still never-held:
--
-- > let Just l0s = applyMove (Move uES wB wB (Qty 1000)) l0
-- > position l0s wB uES
-- Nothing
--
-- Apply one trade -- 1000 from SELLER to BUYER -- and check conservation.
--
-- > let Just l1 = applyMove (Move uES wS wB (Qty 1000)) l0
-- > position l1 wB uES
-- Just (PositionState {psBal = 1000, psHwm = 0})
--
-- > position l1 wS uES
-- Just (PositionState {psBal = -1000, psHwm = 0})
--
-- > netBal l1 uES
-- 0
--
-- The transfer's two legs are inverses, so the sum over holders is zero. That is
-- conservation, and it held because of the shape, not because we audited it.
--
-- A settle overwrites status; the held quantities are untouched, so it cannot
-- change any holding sum -- conservation is undisturbed by a non-transfer event.
--
-- > let Just l1s = settle uES (Price 4200) l1
-- > unitStatus l1s uES
-- Just (UnitStatus {usLifecycle = Active (Price 4200)})
-- > netBal l1s uES
-- 0
--
-- Now close both positions out -- 1000 back from BUYER to SELLER.
--
-- > let Just l2 = applyMove (Move uES wB wS (Qty 1000)) l1s
-- > position l2 wB uES
-- Just (PositionState {psBal = 0, psHwm = 0})
--
-- > position l2 (WalletId "OTHER") uES
-- Nothing
--
-- > netBal l2 uES
-- 0
--
-- The closed-out buyer is `Just (... psBal = 0 ...)` -- held and flat, its row
-- retained -- while a wallet that never traded is still `Nothing`. The
-- distinction from step 3 is doing its job at full size, and conservation is
-- still zero.

-- =============================================================================
-- 9.  Replay is a fold, and that is why it is deterministic.
-- =============================================================================
--
-- An event is one thing that happened: a unit was registered, a quantity moved,
-- or a unit settled. Registration is an event like any other -- it is the event
-- that *introduces* a unit -- so the stream, replayed from `emptyLedger`, brings
-- a unit into being and then acts on it, with no boundary input smuggled in
-- alongside. Three event classes, one wrapper; further classes can be added
-- without changing what follows.

data Event
  = Registered UnitId TermsVersion
  | Moved Move
  | Settled UnitId Price
  deriving (Eq, Show)

apply :: Event -> Ledger -> Maybe Ledger
apply (Registered u tv) = register u tv
apply (Moved m)         = applyMove m
apply (Settled u px)    = settle u px

-- "Apply each event in turn, threading the ledger through, and stop at the first
-- refusal" is a left fold whose step may fail -- that is `foldM` in the `Maybe`
-- monad. We only name it now, because now it is plainly the word for what is on
-- the page:

replay :: [Event] -> Ledger -> Maybe Ledger
replay events l0 = foldM (flip apply) l0 events

-- Replay is deterministic for one reason: `apply` is a *pure, total function of
-- the event and the prior ledger*. The same events, threaded from the same
-- start, give the same ledger -- there is no clock, no randomness, nothing
-- hidden for the order to disturb. That same purity is what makes checkpointing
-- sound: a `foldM` over a concatenation is the `foldM` of the first part, then
-- the `foldM` of the second from where it left off (the monadic left-fold law),
-- so it does not matter where you cut the stream to take a checkpoint. The two
-- sides can differ only if one refuses an event -- and then they refuse
-- together.
--
-- Separately, and not as the cause of any of the above: a closed-out position is
-- *kept* as a flat row (step 8) rather than deleted. That is a property in its
-- own right -- it serves audit and history, and it keeps the never-held versus
-- held-and-flat distinction (step 3) intact across a checkpoint. It is not what
-- makes replay a fold; the fold and its determinism come from `apply` being
-- pure, whether or not any rows are retained.
--
-- And every view is reconstructed by the same fold, starting from `emptyLedger`
-- and nothing else. Because `Registered` is an event, the stream introduces the
-- unit; because `Settled` is an event, the stream rebuilds the lifecycle stage and
-- the settlement price it carries; because `Moved` is an event, it rebuilds the
-- positions. There is no
-- boundary input the fold cannot see: "every view is a projection of the stream"
-- is here literally true -- terms, status, and positions all come from replaying
-- the events over the empty ledger.
--
-- > let uES = UnitId "ES"
-- > let wB  = WalletId "BUYER"
-- > let wS  = WalletId "SELLER"
-- > let eR  = Registered uES (TermsVersion "ES-v1")
-- > let e1  = Moved (Move uES wS wB (Qty 1000))
-- > let eS  = Settled uES (Price 4200)
-- > let e2  = Moved (Move uES wB wS (Qty 1000))
--
-- The stream alone, from the empty ledger, rebuilds terms and status:
--
-- > replay [eR] emptyLedger >>= \l -> Just (productTerms l uES, unitStatus l uES)
-- Just (Just (ProductTerms (TermsVersion {tvLabel = "ES-v1"} :| [])),Just (UnitStatus {usLifecycle = Unsettled}))
--
-- A second registration of the same unit is refused, mid-stream like any other
-- malformed event -- the fold stops at the first refusal:
--
-- > replay [eR, eR] emptyLedger
-- Nothing
--
-- > replay [eR, e1, eS, e2] emptyLedger == (replay [eR, e1] emptyLedger >>= replay [eS, e2])
-- True
--
-- Replaying the whole stream equals replaying a prefix, checkpointing, and
-- replaying the rest. The two are equal because both are the same fold of the
-- same pure step.

-- =============================================================================
-- 10.  The answer, in one breath.
-- =============================================================================
--
-- Unit state lives in three homes and no fourth: immutable versioned *terms* for
-- the unit, shared mutable *status* for the unit, and per-position *state* for
-- each (holder, unit) -- the last being the held-balance map enriched, with an
-- accessor that tells "never held" apart from "held and now flat". Each home is
-- forced by one concrete reason: per-position state, because two holders of one
-- contract differ; shared status, because one settlement number is read
-- identically by all; terms apart from status, because their change disciplines
-- differ -- terms are appended and kept (`appendVersion`, the prior versions
-- preserved because terms are externally authored), status is overwritten on each
-- settle (`settle` discards the prior value), and two such disciplines cannot
-- share one value. Three homes, but two maps, not three: terms and status share the unit key,
-- so they ride together as a pair under one key -- their co-presence is the shape
-- of the map, not an invariant to police -- while each half keeps its own change
-- discipline. The "no fourth home" half of the headline is conditional, and said
-- so: it holds *given* that every per-wallet economic fact reifies as a position
-- in some unit -- a reification shown here for one mandate (n = 1) and assumed for
-- the general multi-instrument case, not proved. Conservation falls out of a move
-- being a *transfer* -- two legs that are
-- inverses in the group `Qty`, inseparable by construction, written into the
-- stored `psBal`; a settle moves no quantity, so it leaves every holding sum
-- untouched. It is an invariant of the writer, not of the store type: the store
-- could hold a non-conserving map, but the only door that writes the balance
-- writes it balanced, and the sealed constructor leaves no other door -- so every
-- reachable ledger conserves from the empty one. Deterministic replay falls out
-- of `apply` being a pure, total function: the same events give the same ledger
-- from any checkpoint (the monadic left-fold law). Registration, settle, and move
-- are all events, so replaying the stream from the *empty* ledger rebuilds every
-- view -- terms, status, positions -- from the stream and nothing else: every view
-- is a projection of the stream, with no boundary input smuggled in. Closed positions are kept as
-- flat rows -- a separate property, for audit and to keep never-held apart from
-- held-and-flat across a checkpoint -- not the cause of determinism. The `Maybe`
-- on a move guards malformed input (an unregistered unit), never the balance.
--
-- Two kinds of fact, and the file keeps them apart rather than dressing one as
-- the other. Some are carried by the *shape* and asserted nowhere: a settlement
-- price present exactly when the unit is active (it rides on the `Active`
-- constructor); terms that are never versionless (a `NonEmpty`); terms and
-- status co-present or both absent (one entry holding both halves); a balance
-- keyed by both wallet and unit; a move that is two cancelling legs from one
-- quantity. These the type guarantees -- the illegal value cannot be written.
-- The others are *not* carried by the store type and hold only by a short
-- soundness argument over the reachable ledgers: conservation (the only door
-- that writes a balance writes it balanced, and the sealed constructor leaves
-- no other door, so every reachable ledger sums to zero); the append-only terms
-- history (`register` refuses a unit it already knows, and the sealed
-- constructor admits no hand-built short history); and the unregistered-unit
-- gate (`applyMove` and `settle` refuse a unit the stream never introduced).
-- The first kind the type makes unrepresentable; the second the writers and the
-- seal make true -- and the value of saying which is which is that the reader is
-- never asked to take a writer discipline on faith as though it were a shape.

-- =============================================================================
-- Runnable check.  `runghc States.hs` prints the milestones above.
-- =============================================================================

main :: IO ()
main = do
  let uES = UnitId "ES"
      wB  = WalletId "BUYER"
      wS  = WalletId "SELLER"
      eR  = Registered uES (TermsVersion "ES-v1")  -- registration: a unit is born
      e1  = Moved (Move uES wS wB (Qty 1000))      -- 1000 leaves SELLER, arrives BUYER
      eS  = Settled uES (Price 4200)               -- a settle: status overwritten
      e2  = Moved (Move uES wB wS (Qty 1000))      -- and back: both flat
      stream = [eR, e1, eS, e2]

  putStrLn "registration is refused for a unit already registered (Nothing)"
  case register uES (TermsVersion "ES-v1") emptyLedger of
    Nothing -> putStrLn "unexpected: ES was new"
    Just l0 -> do
      print (register uES (TermsVersion "ES-v2") l0)   -- Nothing: history intact
      putStrLn "untraded: status present, position absent"
      print (unitStatus l0 uES)        -- Just (UnitStatus {usLifecycle = Unsettled})
      print (position   l0 wB uES)     -- Nothing

  putStrLn "move into an unregistered unit is rejected (malformed input -> Nothing)"
  print (apply (Moved (Move (UnitId "X") wB wS (Qty 1))) emptyLedger)  -- Nothing

  putStrLn "a zero move is well-formed but conjures no row (still never-held)"
  case register uES (TermsVersion "ES-v1") emptyLedger >>=
       applyMove (Move uES wB wS (Qty 0)) of
    Nothing  -> putStrLn "unexpected: a zero move on a registered unit is well-formed"
    Just l0z -> print (position l0z wB uES, position l0z wS uES)   -- (Nothing,Nothing)

  putStrLn "a self-move (from == to) nets to zero, so it too conjures no row"
  case register uES (TermsVersion "ES-v1") emptyLedger >>=
       applyMove (Move uES wB wB (Qty 1000)) of
    Nothing  -> putStrLn "unexpected: a self-move on a registered unit is well-formed"
    Just l0s -> print (position l0s wB uES)   -- Nothing

  putStrLn "replay rebuilds every view from emptyLedger -- terms, status, positions"
  case replay stream emptyLedger of
    Nothing -> putStrLn "unexpected: the stream is well-formed"
    Just lN -> do
      print (productTerms lN uES)                  -- Just (ProductTerms (... "ES-v1" :| []))
      print (unitStatus lN uES)                    -- Just (UnitStatus {usLifecycle = Active (Price 4200)})
      print (position   lN wB uES)                 -- Just (PositionState {psBal = 0, ...})
      print (position   lN (WalletId "OTHER") uES) -- Nothing
      print (netBal     lN uES)                    -- 0: conserved across moves and settles

  putStrLn "replay is checkpoint-independent (purity of apply)"
  print (replay stream emptyLedger == (replay [eR, e1] emptyLedger >>= replay [eS, e2]))  -- True
