import type { BsConfig } from './BsConfig';
import type { BsDiagnostic, FileResolver } from './interfaces';
import { Program } from './Program';
import { Logger } from './Logger';
import PluginInterface from './PluginInterface';
/**
 * A runner class that handles
 */
export declare class ProgramBuilder {
    constructor();
    /**
     * Determines whether the console should be cleared after a run (true for cli, false for languageserver)
     */
    allowConsoleClearing: boolean;
    options: BsConfig;
    private isRunning;
    private watcher;
    program: Program;
    logger: Logger;
    plugins: PluginInterface;
    private fileResolvers;
    addFileResolver(fileResolver: FileResolver): void;
    /**
     * Get the contents of the specified file as a string.
     * This walks backwards through the file resolvers until we get a value.
     * This allow the language server to provide file contents directly from memory.
     */
    getFileContents(srcPath: string): Promise<string>;
    /**
     * A list of diagnostics that are always added to the `getDiagnostics()` call.
     */
    private staticDiagnostics;
    addDiagnostic(srcPath: string, diagnostic: Partial<BsDiagnostic>): void;
    getDiagnostics(): BsDiagnostic[];
    run(options: BsConfig): Promise<void>;
    protected createProgram(): Program;
    protected loadPlugins(): void;
    /**
     * `require()` every options.require path
     */
    protected loadRequires(): void;
    private clearConsole;
    /**
     * A handle for the watch mode interval that keeps the process alive.
     * We need this so we can clear it if the builder is disposed
     */
    private watchInterval;
    enableWatchMode(): void;
    /**
     * The rootDir for this program.
     */
    get rootDir(): string;
    /**
     * A method that is used to cancel a previous run task.
     * Does nothing if previous run has completed or was already canceled
     */
    private cancelLastRun;
    /**
     * Run the entire process exactly one time.
     */
    private runOnce;
    private printDiagnostics;
    /**
     * Run the process once, allowing cancelability.
     * NOTE: This should only be called by `runOnce`.
     */
    private _runOnce;
    private createPackageIfEnabled;
    private transpileThrottler;
    /**
     * Transpiles the entire program into the staging folder
     */
    transpile(): Promise<void>;
    private deployPackageIfEnabled;
    /**
     * Parse and load the AST for every file in the project
     */
    private loadAllFilesAST;
    /**
     * Remove all files from the program that are in the specified folder path
     * @param srcPath the path to the
     */
    removeFilesInFolder(srcPath: string): void;
    /**
     * Scan every file and resolve all variable references.
     * If no errors were encountered, return true. Otherwise return false.
     */
    private validateProject;
    dispose(): void;
}
