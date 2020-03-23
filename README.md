# TwitterClone

This application allows users to create profiles and post content,
called Dweeds (not to be confused with Tweets), on their walls

Users can follow other users and be followed by others.
The user is provided with a news feed with updates from users they follow.

This all may sounds familiar, but we are definitely not Twitter.

### Table of Contents
- [Getting Started](#getting-started)
- [Dweeding](#dweeding)
- [Following](#following)
- [About](#about)

## Getting Started

Sign up and create a profile from our home page to start Dweeding!
https://kavish-dwidder.herokuapp.com/

Not ready to sign up yet? You can view users and their dweeds from their
profile page https://kavish-dwidder.herokuapp.com/users/{id}

## Dweeding

Once you sign up, you are ready! Go to the home page, or your profile and create
your first dweeds. The more you dweed, the more followers you attract. Dweeds
you create show up on your news feed, and that of your followers. All your
dweeds also show up on your profile.

## Following

Once you've created your profile, and are ready to follow others, you can visit
the Users page, and view a list of currently signed up users. You can visit any
of the pages and decide if you'd like to follow them. Once ready, you can simply
click the Follow button on their profile. As soon as you do that, we update your
feed with the dweeds of the person you just followed

## About

This was my first attempt at a Ruby on Rails application. It is loosely based on
Michael Hartl's tutorial for Ruby on Rails. The app is tested with 100% coverage
using RSpec for unit testing and Capybara for integration and UI testing.

This is a work in progress. Current features include basic creation/updating
profiles, dweeding, following other users. Future features include password
resets, dweeding pictures, hashtags, searching for users and hashtags, and
many more.

Remember, this app is not Twitter, so I wouldn't look for Justin Bieber here.
