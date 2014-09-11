# Facebook mass unfollow

Keep your timeline empty by unfollowing all your friends.

1. Clone this repo

2. Create a configuration file (~/.facebook.yml):

```yaml
email: <your fb email>
password: <your fb password>
follow_all: false
```

3. Install the dependencies:

```shell
bundle install
```

4. Run the script:

```shell
ruby fb-mass_unfollow.rb
```

5. Win!