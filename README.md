This app utilizes Maanmittauslaitos (National Land Survey of Finland) API and Google Maps API. For Google Maps API the user must have a working Google API key. https://developers.google.com/maps/documentation/javascript/get-api-key

After acquiring the API key the user must open this project and go to android\app\src\main\res\values\ and then create a file called google_maps_key.xml
Then copypaste this: 
<resources>
      <string name="google_maps_key" templateMergeStrategy="preserve"
          translatable="false">INSERT GOOGLE MAPS API KEY HERE</string>
</resources>
And once you've copied the API key to the place described the app should start running. If you tried to run the app before this, uninstall it and try again.
