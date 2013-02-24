#!/usr/bin/env runhaskell

import System.Directory
import System.FilePath
import Helpers.Directory
import System.Exit
import qualified Data.Vector as V

creaSubM :: FilePath -> IO ()
creaSubM dir = do
  cDir <- getCurrentDirectory
  setCurrentDirectory dir
  mapM_ createDirectory ["var","cur","tmp"]
  setCurrentDirectory cDir

main :: IO ()
main = do
  getHomeDirectory >>= setCurrentDirectory
  isCour <- doesDirectoryExist "courrier"
  if isCour
     then exitFailure
     else do
       createDirectory "courrier"
       setCurrentDirectory "courrier"
       V.mapM_ createDirectory mySub
       V.mapM_ creaSubM mySub
       exitSuccess
 where
  mySub = V.fromList ["proxy","haskell","empire","envoyés","kapA","kapE","spam","var"]

--EOF
