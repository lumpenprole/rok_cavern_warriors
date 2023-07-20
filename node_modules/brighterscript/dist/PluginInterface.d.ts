import type { CompilerPlugin } from './interfaces';
import type { Logger } from './Logger';
export declare type Arguments<T> = [T] extends [(...args: infer U) => any] ? U : [T] extends [void] ? [] : [T];
export default class PluginInterface<T extends CompilerPlugin = CompilerPlugin> {
    private plugins;
    private logger;
    constructor(plugins: CompilerPlugin[], logger: Logger);
    /**
     * Call `event` on plugins
     */
    emit<K extends keyof T & string>(event: K, ...args: Arguments<T[K]>): void;
    /**
     * Add a plugin to the beginning of the list of plugins
     */
    addFirst<T extends CompilerPlugin = CompilerPlugin>(plugin: T): T;
    /**
     * Add a plugin to the end of the list of plugins
     */
    add<T extends CompilerPlugin = CompilerPlugin>(plugin: T): T;
    has(plugin: CompilerPlugin): boolean;
    remove<T extends CompilerPlugin = CompilerPlugin>(plugin: T): T;
    /**
     * Remove all plugins
     */
    clear(): void;
}
