"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BusyStatus = exports.BusyStatusTracker = void 0;
const eventemitter3_1 = require("eventemitter3");
/**
 * Tracks the busy/idle status of various sync or async tasks
 * Reports the overall status to the client
 */
class BusyStatusTracker {
    constructor() {
        /**
         * @readonly
         */
        this.activeRuns = new Set();
        this.emitter = new eventemitter3_1.EventEmitter();
    }
    /**
     * Start a new piece of work
     */
    run(callback, label) {
        const run = {
            label: label,
            startTime: new Date()
        };
        this.activeRuns.add(run);
        if (this.activeRuns.size === 1) {
            this.emit('change', BusyStatus.busy);
        }
        let isFinalized = false;
        const finalizeRun = () => {
            if (isFinalized === false) {
                isFinalized = true;
                this.activeRuns.delete(run);
                if (this.activeRuns.size <= 0) {
                    this.emit('change', BusyStatus.idle);
                }
            }
        };
        let result;
        //call the callback function
        try {
            result = callback(finalizeRun);
            //if the result is a promise, don't finalize until it completes
            if (typeof (result === null || result === void 0 ? void 0 : result.then) === 'function') {
                return Promise.resolve(result).finally(finalizeRun).then(() => result);
            }
            else {
                finalizeRun();
                return result;
            }
        }
        catch (e) {
            finalizeRun();
            throw e;
        }
    }
    on(eventName, handler) {
        this.emitter.on(eventName, handler);
        return () => {
            this.emitter.off(eventName, handler);
        };
    }
    emit(eventName, value) {
        this.emitter.emit(eventName, value);
    }
    destroy() {
        this.emitter.removeAllListeners();
    }
    /**
     * The current status of the busy tracker.
     * @readonly
     */
    get status() {
        return this.activeRuns.size === 0 ? BusyStatus.idle : BusyStatus.busy;
    }
}
exports.BusyStatusTracker = BusyStatusTracker;
var BusyStatus;
(function (BusyStatus) {
    BusyStatus["busy"] = "busy";
    BusyStatus["idle"] = "idle";
})(BusyStatus = exports.BusyStatus || (exports.BusyStatus = {}));
//# sourceMappingURL=BusyStatusTracker.js.map