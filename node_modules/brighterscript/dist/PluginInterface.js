"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Logger_1 = require("./Logger");
class PluginInterface {
    constructor(plugins, logger) {
        this.plugins = plugins;
        this.logger = logger;
    }
    /**
     * Call `event` on plugins
     */
    emit(event, ...args) {
        for (let plugin of this.plugins) {
            if (plugin[event]) {
                try {
                    this.logger.time(Logger_1.LogLevel.debug, [plugin.name, event], () => {
                        plugin[event](...args);
                    });
                }
                catch (err) {
                    this.logger.error(`Error when calling plugin ${plugin.name}.${event}:`, err);
                }
            }
        }
    }
    /**
     * Add a plugin to the beginning of the list of plugins
     */
    addFirst(plugin) {
        if (!this.has(plugin)) {
            this.plugins.unshift(plugin);
        }
        return plugin;
    }
    /**
     * Add a plugin to the end of the list of plugins
     */
    add(plugin) {
        if (!this.has(plugin)) {
            this.plugins.push(plugin);
        }
        return plugin;
    }
    has(plugin) {
        return this.plugins.includes(plugin);
    }
    remove(plugin) {
        if (this.has(plugin)) {
            this.plugins.splice(this.plugins.indexOf(plugin));
        }
        return plugin;
    }
    /**
     * Remove all plugins
     */
    clear() {
        this.plugins = [];
    }
}
exports.default = PluginInterface;
//# sourceMappingURL=PluginInterface.js.map