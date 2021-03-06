// Generated by CoffeeScript 1.9.2
(function() {
  chrome.runtime.onConnect.addListener(function(port) {
    if (port.name === 'got_token') {
      return port.onMessage.addListener(function(ph_resp) {
        var api;
        api = new Background.Api();
        return api.persist_token(ph_resp);
      });
    }
  });

  chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
    var decider;
    decider = new Background.PageActionDecider(tab);
    return decider.decide();
  });

  this.get_collections = function(id, callback) {
    var api;
    api = new Background.Api();
    return api.authorize(function() {
      return api.retrieve_collections(id, callback);
    });
  };

}).call(this);
