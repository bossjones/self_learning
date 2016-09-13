import Data.List

-- H-99: Ninety-Nine Haskell Problems
-- https://wiki.haskell.org/99_questions

--
-- Tree implementation
-- 

data Tree a = Node a (Tree a) (Tree a)
            | Nil
              deriving (Eq)

instance Show a => Show (Tree a)
  where show Nil = "Nil"
        show (Node x Nil Nil) = "L:" ++ show x
        show (Node x l r) = "(Node " ++ show x ++ " " ++ show l ++ " " ++ show r ++ ")"

type T = Tree Char              

leaf = Node 'x' Nil Nil

isLeaf :: T -> Bool
isLeaf (Node _ Nil Nil) = True
isLeaf _ = False

isFull :: T -> Bool
isFull Nil = True
isFull (Node _ l r) = isFull l && isFull r && (height l == height r)

isBalanced :: T -> Bool
isBalanced Nil = True
isBalanced (Node _ l r) = isBalanced l && isBalanced r && (height l == height r)

-- height of tree  
height :: T -> Int
height Nil = 0
height (Node _ l r) = 1 + max (height l) (height r)

-- add node to leftmost position
addNodeL :: T -> T
addNodeL Nil = leaf
addNodeL (Node v l r) = (Node v (addNodeL l) r)

-- add node to rightmost position
addNodeR :: T -> T
addNodeR Nil = leaf
addNodeR (Node v l r) = (Node v l (addNodeR r))

-- add node to the right of last node
addNodeRH :: T -> T
addNodeRH t
  | isBalanced t = addNodeL t
  | isRightFull t = Nil         -- cannot add node to this tree
  | otherwise = helper t
    where helper Nil = leaf
          helper (Node v l r)
            | isBalanced l && isBalanced r = Node v l (addNodeL r) -- l(h+1), r(h)
            | hasSingleLeftChild l = Node v (helper l) r
            | isRightFull l && isBalanced r = Node v l (addNodeL r)
            | otherwise = Node v l (helper r)

-- Tree contains a Node with a left child and no right child
hasSingleLeftChild :: T -> Bool
hasSingleLeftChild Nil = False
hasSingleLeftChild (Node _ Nil Nil) = False
hasSingleLeftChild (Node _ l Nil) = True
hasSingleLeftChild (Node _ l r) = hasSingleLeftChild l || hasSingleLeftChild r

-- true if right most position of tree contains a leaf
isRightFull :: T -> Bool
isRightFull t
  | isBalanced t = True
isRightFull (Node _ Nil Nil) = True -- base case at far right of tree
isRightFull (Node _ l r) = (height l < height r) && isRightFull r

{-
Problem 55
(**) Construct completely balanced binary trees

In a completely balanced binary tree, the following property holds for every
node: The number of nodes in its left subtree and the number of nodes in its
right subtree are almost equal, which means their difference is not greater than
one.

Write a function cbal-tree to construct completely balanced binary trees for a
given number of nodes. The predicate should generate all solutions via
backtracking. Put the letter 'x' as information into all nodes of the tree.
-}

-- value of Node is not important to this problem

solve :: Int -> [T]
solve 1 = [leaf]
solve n = nub . concat . map cultivate $ solve (n-1) 

-- build list of all balanced trees by adding node to tree
cultivate :: T -> [T]
cultivate t
  | isBalanced t = helper (addNodeL t)
  | isRightFull t = []
  | otherwise = helper (addNodeRH t)
  where helper Nil = []
        helper t = t : helper (mvR t)

-- move rightmost node right one position
mvR :: T -> T
mvR (Node a x@(Node b Nil Nil) Nil) = Node a Nil x -- left child to right
mvR (Node a (Node b Nil x@(Node _ Nil Nil)) (Node c Nil Nil))
  = Node a (Node b Nil Nil) (Node c x Nil)
mvR (Node a (Node b y@(Node _ Nil Nil) x@(Node _ Nil Nil)) (Node c Nil Nil))
  = Node a (Node b y Nil) (Node c x Nil)
mvR (Node v l r)
  | canMove l = Node v (mvR l) r
  | canMove r = Node v l (mvR r)
  | otherwise = Nil             -- needed for recusive termination
  where canMove t = (not $ isBalanced t) && (not $ isRightFull t)

--
-- test data
--

x = 'x'
e = Nil                                          -- h = 0
l = leaf                                         -- h = 1
tL = (Node x leaf Nil)                           -- h = 2
tR = (Node x Nil leaf)                           -- h = 2
tB = (Node x leaf leaf)

t1 = (Node x (Node x leaf Nil) leaf)             -- h = 3
t2 = (Node x (Node x Nil leaf) leaf)             -- h = 3
t3 = (Node x leaf (Node x leaf Nil))             -- h = 3
t4 = (Node x leaf (Node x Nil leaf))             -- h = 3

tx = (Node x (Node x leaf leaf) leaf)
ty = (Node x (Node x leaf leaf) (Node x leaf Nil))
tz = (Node x (Node x Nil leaf) (Node x leaf Nil))



{-
Problem 56
(**) Symmetric binary trees

Let us call a binary tree symmetric if you can draw a vertical line through the
root node and then the right subtree is the mirror image of the left
subtree. Write a predicate symmetric/1 to check whether a given binary tree is
symmetric. Hint: Write a predicate mirror/2 first to check whether one tree is
the mirror image of another. We are only interested in the structure, not in the
contents of the nodes.
-}

symmetric :: Eq a => Tree a -> Bool
symmetric Nil = True
symmetric (Node _ l r) = mirror l r

mirror :: Eq a => Tree a -> Tree a -> Bool
mirror t1 t2 = t1 `structureEq` reverseTree t2
  where reverseTree (Node v l r) = (Node v (reverseTree r) (reverseTree l))
        reverseTree Nil = Nil

structureEq :: Tree a -> Tree a -> Bool
structureEq Nil Nil = True
structureEq (Node _ Nil Nil) (Node _ Nil Nil) = True
structureEq (Node _ Nil r1) (Node _ Nil r2) = structureEq r1 r2
structureEq (Node _ l1 Nil) (Node _ l2 Nil) = structureEq l1 l2

{-
Problem 57
(**) Binary search trees (dictionaries)

Use the predicate add/3, developed in chapter 4 of the course, to write a
predicate to construct a binary search tree from a list of integer numbers.
-}

add :: Ord a => a -> Tree a -> Tree a
add v Nil = Node v Nil Nil
add v (Node w l r)
  | v < w = Node w (add v l) r
  | v > w = Node w l (add v r)
  | otherwise = error "tree values must be nique"


root v = Node v Nil Nil 

construct :: Ord a => [a] -> Tree a
construct xs = addAlternating Nil (reverse front) back
  where (front,back) = splitInHalf $ sort xs

addAlternating :: Ord a => Tree a -> [a] -> [a] -> Tree a
addAlternating t (x:xs) (y:ys) = addAlternating (add y (add x t)) xs ys
addAlternating t [] [y] = add y t
addAlternating t [x] [] = add x t

splitInHalf :: [a] -> ([a],[a])
splitInHalf xs = ((take n xs),(drop n xs))
  where n = 1 + (quot (length xs ) 2)

{-
Problem 58
(**) Generate-and-test paradigm

Apply the generate-and-test paradigm to construct all symmetric, completely
balanced binary trees with a given number of nodes.
-}

--symCbalTrees = 
