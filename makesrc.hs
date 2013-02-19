#!/usr/bin/env runhaskell

{- makesrc.hs | 10 Fév. 2013 à 21h40 | GPLv3 -}

import System.Environment (getArgs)
import System.Cmd         (rawSystem)
import System.Directory
import System.FilePath

main = do
    [file] <- getArgs
    let nameFile = takeBaseName file
    rawSystem "hmake" [nameFile]
    home <- getHomeDirectory
    let
      nameExe  = nameFile ++ ".exe"
      homeFile = home ++ "\\.opt\\bin\\" ++ nameExe
    copyFile nameExe homeFile
    removeFile nameExe
--EOF
