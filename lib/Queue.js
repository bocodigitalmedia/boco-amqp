// Generated by CoffeeScript 1.6.3
(function() {
  var Queue, QueueOptions;

  Queue = (function() {
    function Queue(properties) {
      if (properties == null) {
        properties = {};
      }
      this.name = properties.name;
      this.setOptions(properties.options);
    }

    Queue.prototype.setOptions = function(options) {
      return this.options = new QueueOptions(options);
    };

    return Queue;

  })();

  QueueOptions = (function() {
    function QueueOptions(properties) {
      if (properties == null) {
        properties = {};
      }
      this.exclusive = properties.exclusive;
      this.durable = properties.durable;
      this.autoDelete = properties.autoDelete;
      this["arguments"] = properties["arguments"];
      this.setDefaults();
    }

    QueueOptions.prototype.setDefaults = function() {
      if (this.exclusive == null) {
        this.exclusive = false;
      }
      if (this.durable == null) {
        this.durable = false;
      }
      if (this.autoDelete == null) {
        return this.autoDelete = false;
      }
    };

    return QueueOptions;

  })();

  module.exports = Queue;

}).call(this);

/*
//@ sourceMappingURL=Queue.map
*/
