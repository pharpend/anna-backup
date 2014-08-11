{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.ByteString.Lazy (ByteString)
import           Data.Monoid ((<>))
import           Hakyll

main :: IO ()
main = hakyll $ do
  match "images/*" $ do
    route idRoute
    compile copyFileCompiler

  match "stylesheets/*" $ do
    route $ setExtension "css"
    compile sass

  match "pages/*" $ do
    route $ (gsubRoute "pages/" (const "")) `composeRoutes` setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "templates/*" $ compile templateCompiler

sass = getResourceLBS
  >>= withItemBody (unixFilterLBS "sass" ["--stdin", "--style", "compressed"])
