# ChatForTinkoff

[![Build Status](https://travis-ci.com/aliaksandra-kolesava/ChatForTinkoff.svg?branch=homework-13)](https://travis-ci.com/aliaksandra-kolesava/ChatForTinkoff)

### Author
Aliaksandra Kolesava

### Installation all dependencies
#### Pods
1. Add Pods (open project directory in terminal)
```
pod install
```
#### Creation Config.xcconfig
1. Create file Config.xcconfig and add there the following
```
PIXABAY_API_KEY = YourAPI
```
where YourAPI is a api key, which you can create in https://pixabay.com/api/docs/
#### Discord Notifier
1. Add fastlane discord_notifier plugin
```
fastlane add_plugin discord_notifier
```
2. Add package
```
brew install libsodium
```
3. Create file .env in fastlane directory and set there a variable
```
DISCORD_WEBHOOK_URL="YourWebhook_url"
```
