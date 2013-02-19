#!/usr/bin/env runhaskell

-- chmake2.hs
-- Modifié le: 07 Fév.2013 à 22h14

import System.Directory
import System.FilePath
import Data.List ( (\\) )

main = do
  dir <- getDirectoryContents "."
  mapM_ removeFile $ filter (\x -> takeExtension x `elem` [".hi",".o"]) dir \\ [".",".."]


-- EOF
