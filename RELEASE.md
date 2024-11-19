### Breaking Changes
* /keeweb/www is now /keeweb/var. Store all your databases in /keeweb/var.
* All config files are dynamically created via online configuration. See the compose.yaml how that works.
* Remove volume /keeweb/etc

### New Features
* Inline configuration

### Performance Improvements
* Drop custom SSL configuration