/**
 * Tracks the busy/idle status of various sync or async tasks
 * Reports the overall status to the client
 */
export declare class BusyStatusTracker {
    /**
     * @readonly
     */
    activeRuns: Set<{
        label?: string;
        startTime?: Date;
    }>;
    /**
     * Start a new piece of work
     */
    run<T, R = T | Promise<T>>(callback: (finalize?: FinalizeBuildStatusRun) => R, label?: string): R;
    private emitter;
    on(eventName: 'change', handler: (status: BusyStatus) => void): () => void;
    private emit;
    destroy(): void;
    /**
     * The current status of the busy tracker.
     * @readonly
     */
    get status(): BusyStatus;
}
export declare type FinalizeBuildStatusRun = (status?: BusyStatus) => void;
export declare enum BusyStatus {
    busy = "busy",
    idle = "idle"
}
