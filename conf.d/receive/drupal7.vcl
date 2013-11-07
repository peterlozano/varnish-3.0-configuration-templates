# A configuration file specific for Drupal 7

# Either the admin pages or the login
if (req.url ~ "/admin/?") {
    # Don't cache, pass to backend
    return (pass);
}

# Static content unique to the theme can be cached (so no user uploaded images)
# Before you blindly enable this, have a read here: http://mattiasgeniar.be/2012/11/28/stop-caching-static-files/
if (req.url ~ "^/themes/" && req.url ~ "\.(css|js|png|gif|jp(e)?g)") {
    unset req.http.cookie;
}

# Don't cache the install, update or cron files in Drupal
if (req.url ~ "install\.php|update\.php|cron\.php") {
    return (pass);
}

# Uncomment this to trigger the vcl_error() subroutine, which will HTML output you some variables (HTTP 700 = pretty debug)
#error 700;

# Do not cache users with session cookie, these may be:
# * Authenticated users, never cache!
# * Some modules generate session cookie even for anonymous users, for these modules to work
#   caching must stop as long as there is a SESS* cookie
if (req.http.Cookie ~ "SESS") {
    return (pass);
}

# If no session cookie, all other cookies can go to the trash
unset req.http.cookie;

# Try a cache-lookup
return (lookup);
