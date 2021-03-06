# Project 3 - Twitter Demo

Twitter Demo is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: 30+ hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
[] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

[x] Spent time adding additonal logic to the character limit. 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I'd like to spend more time on delegates -- they seem to be powerful and I want to make sure I'm leveraging them appropriately.
2. I'd like to discuss best practices for inserting animations.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![alt tag](https://raw.githubusercontent.com/anjlal/twitterdemo/master/twitterdemo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I wasn't able to successfully unretweet in the detail view if a tweet had been retweeted in the timeline; I'd like to explore that more. Overall, I spent more time on UI as compared to previous projects (especially auto-layout) and feel like I understand delegates better. Also I was able to get the composed tweet to show up without having to make a newtwork call, but I think something broke in between now and then. I will fix.

# Project 4 - Twitter Redux

Time spent: 20+ hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Hamburger menu
   - [x] Dragging anywhere in the view should reveal the menu.
   - [x] The menu should include links to your profile, the home timeline, and the mentions view.
   - [x] The menu can look similar to the example or feel free to take liberty with the UI.
- [x] Profile page
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] Profile Page
   - [x] Implement the paging view for the user description.
   - [x] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account


The following **additional** features are implemented:

- [x] Added animations to paging view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

  1. Animations
  2. Passing data around


## Video Walkthrough

Here's a walkthrough of implemented user stories:

![alt tag](https://raw.githubusercontent.com/anjlal/twitterdemo/master/twitterredux.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
The thing that took me the longest was around the various ways of passing data between view controllers and when to use navigation controllers -- I think I have a better understanding but still have not fully grasped all the nuances between the various approaches. For example, I played around with Notifications but they didn't always work as expected. I also wish I had created a xib file for some of my cells earlier on -- that would have saved me time. I'm really eager to get the stretchy header to work, so I will continue iterating on it.

## License

    Copyright [2017] [Angie Lal]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
