#!/usr/bin/env runhaskell

import System.Environment (getArgs)
import System.Directory   (getDirectoryContents)
import Data.List          ( (\\) )
import qualified Data.Text    as T
import qualified Data.Text.IO as T

shuffleFile n fi = do
  hfi <- T.readFile fi
  T.writeFile fi $ T.unlines (take n $ cycle $ T.lines hfi)

main = do
  args <- getArgs
  case args of
    (mode:fi:n:_) -> do
      case mode of
        "-f" -> shuffleFile (read n) fi
        "-d" -> do
          cts <- getDirectoryContents fi
          mapM_ (shuffleFile (read n)) (cts \\ [".",".."])
    (fi:n:_)      -> shuffleFile (read n) fi
    _             -> error "invalid input"

--EOF
