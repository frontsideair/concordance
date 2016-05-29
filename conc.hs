import System.Environment
import Data.List
import Data.List.Split
import qualified Data.Char as Char
import Data.Monoid
import Data.Maybe
import Control.Monad
import Data.Hashable
import qualified Data.Map.Strict as Map

-- import Data.Array.Accelerate as A
-- import Data.Array.Accelerate.Interpreter as I

newtype CharX = CharX { getTuple :: (Int, Char) } deriving Show

instance Eq CharX where CharX (_, c1) == CharX (_, c2) = c1 == c2

main :: IO ()
main = do
    args <- getArgs
    case args of
        (filename:maxLength:_) -> do
            file <- readFile filename
            let lower = Char.toLower <$> file
            let fileWithIndices = CharX <$> zip [1..] lower
            let rawWords = splitWords fileWithIndices
            let words = collapseWordIndices rawWords
            let subs = continuousSubSeqs words
            let filtered = filter (\xs -> length xs <= read maxLength && length xs /= 0) subs
            let indexed = collapseSeqIndices filtered
            let set = foldl (\acc (i, s) -> Map.insertWith (++) s [i] acc) Map.empty indexed
            (putStrLn . show) $ Map.filter (\v -> length v > 1) set
        _ -> error "usage: conc filename maxLength"

continuousSubSeqs = filter (not . null) . concatMap inits . tails

collapseWordIndices :: [[CharX]] -> [(Int, String)]
collapseWordIndices words =
    f <$> words where
    f word = case word of
                  [] -> (-1, "")
                  (hd:_) -> ((fst . getTuple) hd, (snd . getTuple) <$> word)

collapseSeqIndices :: [[(Int, String)]] -> [(Int, [String])]
collapseSeqIndices seqs =
    f <$> seqs where
    f seq = case seq of
                 [] -> (-1, [""])
                 (hd:_) -> (fst hd, snd <$> seq)

splitWords = splitBySpace >=> removePunctuation >=> splitByDash

splitBySpace :: [CharX] -> [[CharX]]
splitBySpace = wordsBy (\(CharX (_, c)) -> Char.isSpace c)

splitByDash :: [CharX] -> [[CharX]]
splitByDash str =
    let dash = CharX <$> zip [1..] "--"
    in  splitOn dash str

removePunctuation :: [CharX] -> [[CharX]]
removePunctuation xs = pure $ (removeFromStart . removeFromEnd) xs

removeFromStart :: [CharX] -> [CharX]
removeFromStart = dropWhile (\(CharX (_, c)) -> Char.isPunctuation c)

removeFromEnd :: [CharX] -> [CharX]
removeFromEnd = reverse . removeFromStart . reverse

-- things to do
-- read file to memory: String [DONE]
-- tokenize words with indices: [(String, Int)] [DONE]
-- (optional) split words into smaller chunks (wrt maxLength)
-- generate all possible word sequences wrt maxLength: [(String, Int)]
-- fold this to a map by appending index: { String => [Int] }
-- print the map, by occurrence list length
