gyazz-checker
=============

check [gyaaazz](https://github.com/shokai/gyaaazz). send IM and tweet.


Dependencies
============

* TokyoCabinet
* Twitter
* im-kayac


Setup
=====

git clone

    % git clone git://github.com/shokai/gyaaazz-checker.git


Install Dependencies
--------------------

    # Mac OS X
    % sudo port install tokyocabinet
  
    # Install gems
    % bundle install
    # or
    % sudo gem install tokyocabinet twitter

    % bundle install


Config
------

    % cp sample.config.yaml config.yaml

then edit it.

Twitter update
--------------

regist your app [on twitter](http://twitter.com/apps/new)

edit cosumer_key and secret in config.yaml.

get access_token and secret

    % ruby auth.rb


Run
===

    % ./gyaaazz-checker

Author
======

* shokai