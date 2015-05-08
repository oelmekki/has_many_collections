// Generated by CoffeeScript 1.9.2
(function() {
  var ApiError, Collection, Collections, Contact, Filter, HideSaveForLater, Main, Title, Waiting;

  ApiError = React.createClass({
    render: function() {
      return React.createElement("h2", null, "Sorry, an error occured while contacting product hunt :(");
    }
  });

  Collection = React.createClass({
    open: function() {
      return window.open(this.props.data.collection_url);
    },
    render: function() {
      return React.createElement("li", {
        "className": "collection"
      }, React.createElement("a", {
        "href": this.props.data.collection_url,
        "onClick": this.open
      }, React.createElement("h2", null, React.createElement("span", {
        "className": "count"
      }, this.props.data.posts_count), this.props.data.name), React.createElement("img", {
        "src": this.props.data.user.image_url['30px']
      }), React.createElement("span", {
        "className": "user_name"
      }, this.props.data.user.name)));
    }
  });

  Collections = React.createClass({
    resultsCount: function() {
      if (this.props.items.length > 1) {
        return this.props.items.length + " results.";
      } else {
        return this.props.items.length + " result.";
      }
    },
    render: function() {
      var collection, collections;
      if (this.props.items.length) {
        collections = (function() {
          var i, len, ref, results;
          ref = this.props.items;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            collection = ref[i];
            results.push(React.createElement(Collection, {
              "data": collection,
              "key": collection.id
            }));
          }
          return results;
        }).call(this);
        return React.createElement("div", null, React.createElement("p", {
          "id": "results-count"
        }, this.resultsCount()), React.createElement("ul", {
          "id": "collections"
        }, collections));
      } else {
        return React.createElement("h2", null, "Nothing there (yet).");
      }
    }
  });

  Filter = React.createClass({
    handleChange: function(event) {
      return this.props.onChange(event.target.value);
    },
    render: function() {
      return React.createElement("input", {
        "type": "search",
        "id": "filter",
        "placeholder": "filter...",
        "value": this.props.term,
        "onChange": this.handleChange
      });
    }
  });

  HideSaveForLater = React.createClass({
    handleChange: function(event) {
      return this.props.onChange(event.target.checked);
    },
    render: function() {
      return React.createElement("p", {
        "id": "hide-save-for-later"
      }, React.createElement("label", null, React.createElement("input", {
        "type": "checkbox",
        "defaultChecked": this.props.checked,
        "onChange": this.handleChange
      }), "Hide \"Save for later\" collections"));
    }
  });

  Title = React.createClass({
    render: function() {
      return React.createElement("h1", null, "In Collections", this.props.children);
    }
  });

  Waiting = React.createClass({
    render: function() {
      return React.createElement("div", {
        "id": "waiting"
      }, React.createElement("img", {
        "src": "ajax-loader.gif"
      }));
    }
  });

  Main = React.createClass({
    getInitialState: function() {
      return {
        hideSaveForLater: this.props.hideSaveForLater,
        error: false
      };
    },
    componentDidMount: function() {
      return this.populate();
    },
    populate: function() {
      return this.retrievePageId((function(_this) {
        return function(id) {
          return chrome.runtime.getBackgroundPage(function(bg) {
            return bg.get_collections(id, function(collections) {
              if (collections === 'error') {
                return _this.setState({
                  collections: [],
                  error: true
                });
              } else {
                return _this.setState({
                  collections: collections,
                  error: false
                });
              }
            });
          });
        };
      })(this));
    },
    retrievePageId: function(callback) {
      var retrievingInterval;
      return retrievingInterval = setInterval(function() {
        return chrome.tabs.query({
          active: true
        }, function(tabs) {
          var tab;
          tab = tabs[0];
          return chrome.tabs.executeScript(tab.id, {
            code: "JSON.parse( document.querySelector( '[data-react-class=\"PostDetailHeader\"]' ).dataset.reactProps ).id"
          }, function(id) {
            if (id) {
              clearInterval(retrievingInterval);
              return callback(id);
            }
          });
        });
      }, 500);
    },
    filterCollections: function() {
      return this.state.collections.filter((function(_this) {
        return function(item) {
          return (!_this.state.hideSaveForLater || item.name.toLowerCase().trim() !== 'save for later') && (!_this.state.filter || item.name.toLowerCase().indexOf(_this.state.filter.toLowerCase()) !== -1);
        };
      })(this));
    },
    showInterface: function() {
      var ref;
      return !this.state.error && ((ref = this.state.collections) != null ? ref.length : void 0);
    },
    handleFilterChange: function(term) {
      return this.setState({
        filter: term
      });
    },
    handleSaveForLaterChange: function(isChecked) {
      chrome.storage.sync.set({
        filter_for_later: isChecked
      });
      return this.setState({
        hideSaveForLater: isChecked
      });
    },
    filter: function() {
      if (this.showInterface()) {
        return React.createElement(Filter, {
          "onChange": this.handleFilterChange,
          "term": this.state.filter
        });
      }
    },
    saveForLater: function() {
      if (this.showInterface()) {
        return React.createElement(HideSaveForLater, {
          "checked": this.state.hideSaveForLater,
          "onChange": this.handleSaveForLaterChange
        });
      }
    },
    content: function() {
      if (this.state.error) {
        return React.createElement(ApiError, null);
      } else {
        if (this.state.collections) {
          return React.createElement(Collections, {
            "items": this.filterCollections(),
            "hideSaveForLater": this.state.hideSaveForLater,
            "filter": this.state.filter
          });
        } else {
          return React.createElement(Waiting, null);
        }
      }
    },
    render: function() {
      return React.createElement("div", null, React.createElement(Title, null, this.filter()), this.saveForLater(), this.content(), React.createElement(Contact, null));
    }
  });

  document.addEventListener('DOMContentLoaded', function() {
    return chrome.storage.sync.get('filter_for_later', (function(_this) {
      return function(resp) {
        return React.render(React.createElement(Main, {
          "hideSaveForLater": resp.filter_for_later
        }), document.querySelector('#main'));
      };
    })(this));
  });

  Contact = React.createClass({
    contactUrl: function() {
      return "https://twitter.com/oelmekki";
    },
    handleClick: function() {
      return window.open(this.contactUrl());
    },
    render: function() {
      return React.createElement("p", {
        "id": "contact"
      }, "Any problem? Feel free to ", React.createElement("a", {
        "href": this.contactUrl(),
        "onClick": this.handleClick
      }, "ping me"), ".");
    }
  });

}).call(this);