#!/usr/bin/env runhaskell

-- pdclean2.hs
-- Modifié le: 08 Fév. 2013 à 17h32

import System.Directory
import System.FilePath
import Data.List ( (\\) )

main :: IO ()
main = do
  dir <- getDirectoryContents "."
  mapM_ removeFile $ filter (\x -> takeExtension x `elem` toFilt) $ dir \\ baseF
 where
  toFilt =  [".nav",".toc",".snm",".aux",".log",".tns",".out"]
  baseF = [".",".."]

--EOF
