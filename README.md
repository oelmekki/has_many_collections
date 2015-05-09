# Has many collections

This chrome extension allows to see which collections a product has been put in, on [Product Hunt](https://producthunt.com).

![screenshot](https://raw.githubusercontent.com/oelmekki/has_many_collections/master/screenshot.png)


## Architecture

This extension contains:

* a background page, to handle api and oauth communication
* a page action, handling the main interface for the extension
* a content script, used on hunting-cabin.cc

Page action will appear when browsing a product page on product hunt.
Clicking it the first time will open a tab on hunting-cabin to ask for
oauth authorization on product hunt. When accepted, background page
close hunting-cabin tab.

From then, any product page will allow to click the extension and see
what collections the product has been added to. Simple as that.


## Building

This repos is mostly here to showcase how to use product hunt's API in a chrome
extension. But if you want to base something on it anyway, you have to provide
your oauth domain and path (replace `your_domain`, and `your_path`
accordingly):

```
sed -i 's/OAUTH_DOMAIN/your_domain/' $(git grep -l OAUTH_DOMAIN)
sed -i 's/OAUTH_PATH/your_path/' $(git grep -l OAUTH_PATH)
```

To build coffeescript files (needs, well, [coffeescript](https://github.com/jashkenas/coffeescript)):

```
coffee -cw background_page/ content_script/
```

To build cjsx file (needs [coffee-react](https://github.com/jsdf/coffee-react)):

```
cjsx -cwj page_action/build/has_many_collections.js page_action/cjsx
```


