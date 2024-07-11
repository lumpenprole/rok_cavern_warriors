import 'array-flat-polyfill';
import type { InitializeParams, ServerCapabilities, ExecuteCommandParams, WorkspaceSymbolParams, SymbolInformation, DocumentSymbolParams } from 'vscode-languageserver/node';
import { FileChangeType } from 'vscode-languageserver/node';
import { ProgramBuilder } from './ProgramBuilder';
import { Throttler } from './Throttler';
import { BusyStatusTracker } from './BusyStatusTracker';
export declare class LanguageServer {
    private connection;
    projects: Project[];
    /**
     * The number of milliseconds that should be used for language server typing debouncing
     */
    private debounceTimeout;
    /**
     * These projects are created on the fly whenever a file is opened that is not included
     * in any of the workspace-based projects.
     * Basically these are single-file projects to at least get parsing for standalone files.
     * Also, they should only be created when the file is opened, and destroyed when the file is closed.
     */
    standaloneFileProjects: Record<string, Project>;
    private hasConfigurationCapability;
    /**
     * Indicates whether the client supports workspace folders
     */
    private clientHasWorkspaceFolderCapability;
    /**
     * Create a simple text document manager.
     * The text document manager supports full document sync only
     */
    private documents;
    private createConnection;
    private loggerSubscription;
    private keyedThrottler;
    validateThrottler: Throttler;
    private sendDiagnosticsThrottler;
    private boundValidateAll;
    private validateAllThrottled;
    busyStatusTracker: BusyStatusTracker;
    run(): void;
    private busyStatusIndex;
    private sendBusyStatus;
    /**
     * Called when the client starts initialization
     */
    onInitialize(params: InitializeParams): {
        capabilities: ServerCapabilities<any>;
    };
    private initialProjectsCreated;
    /**
     * Ask the client for the list of `files.exclude` patterns. Useful when determining if we should process a file
     */
    private getWorkspaceExcludeGlobs;
    /**
     * Scan the workspace for all `bsconfig.json` files. If at least one is found, then only folders who have bsconfig.json are returned.
     * If none are found, then the workspaceFolder itself is treated as a project
     */
    private getProjectPaths;
    /**
     * Find all folders with bsconfig.json files in them, and treat each as a project.
     * Treat workspaces that don't have a bsconfig.json as a project.
     * Handle situations where bsconfig.json files were added or removed (to elevate/lower workspaceFolder projects accordingly)
     * Leave existing projects alone if they are not affected by these changes
     */
    private syncProjects;
    /**
     * Get all workspace paths from the client
     */
    private getWorkspacePaths;
    /**
     * Called when the client has finished initializing
     */
    private onInitialized;
    /**
     * Send a critical failure notification to the client, which should show a notification of some kind
     */
    private sendCriticalFailure;
    /**
     * Wait for all programs' first run to complete
     */
    private waitAllProjectFirstRuns;
    /**
     * Event handler for when the program wants to load file contents.
     * anytime the program wants to load a file, check with our in-memory document cache first
     */
    private documentFileResolver;
    private getConfigFilePath;
    /**
     * A unique project counter to help distinguish log entries in lsp mode
     */
    private projectCounter;
    /**
     * @param projectPath path to the project
     * @param workspacePath path to the workspace in which all project should reside or are referenced by
     * @param projectNumber an optional project number to assign to the project. Used when reloading projects that should keep the same number
     */
    private createProject;
    private createStandaloneFileProject;
    private getProjects;
    /**
     * Provide a list of completion items based on the current cursor position
     */
    private onCompletion;
    /**
     * Provide a full completion item from the selection
     */
    private onCompletionResolve;
    private onCodeAction;
    /**
     * Remove a project from the language server
     */
    private removeProject;
    /**
     * Reload each of the specified workspaces
     */
    private reloadProjects;
    private getRootDir;
    /**
     * Sometimes users will alter their bsconfig files array, and will include standalone files.
     * If this is the case, those standalone workspaces should be removed because the file was
     * included in an actual program now.
     *
     * Sometimes files that used to be included are now excluded, so those open files need to be re-processed as standalone
     */
    private synchronizeStandaloneProjects;
    private onDidChangeConfiguration;
    /**
     * Called when watched files changed (add/change/delete).
     * The CLIENT is in charge of what files to watch, so all client
     * implementations should ensure that all valid project
     * file types are watched (.brs,.bs,.xml,manifest, and any json/text/image files)
     */
    private onDidChangeWatchedFiles;
    /**
     * This only operates on files that match the specified files globs, so it is safe to throw
     * any file changes you receive with no unexpected side-effects
     */
    handleFileChanges(project: Project, changes: {
        type: FileChangeType;
        srcPath: string;
    }[]): Promise<void>;
    /**
     * This only operates on files that match the specified files globs, so it is safe to throw
     * any file changes you receive with no unexpected side-effects
     */
    private handleFileChange;
    private onHover;
    private onDocumentClose;
    private validateTextDocument;
    private validateAll;
    onWorkspaceSymbol(params: WorkspaceSymbolParams): Promise<SymbolInformation[]>;
    onDocumentSymbol(params: DocumentSymbolParams): Promise<import("vscode-languageserver-types").DocumentSymbol[]>;
    private onDefinition;
    private onSignatureHelp;
    private onReferences;
    private onValidateSettled;
    private onFullSemanticTokens;
    private diagnosticCollection;
    private sendDiagnostics;
    onExecuteCommand(params: ExecuteCommandParams): Promise<import("./Program").FileTranspileResult>;
    private transpileFile;
    dispose(): void;
}
export interface Project {
    /**
     * A unique number for this project, generated during this current language server session. Mostly used so we can identify which project is doing logging
     */
    projectNumber: number;
    firstRunPromise: Promise<any>;
    builder: ProgramBuilder;
    /**
     * The path to where the project resides
     */
    projectPath: string;
    /**
     * The path to the workspace where this project resides. A workspace can have multiple projects (by adding a bsconfig.json to each folder).
     */
    workspacePath: string;
    isFirstRunComplete: boolean;
    isFirstRunSuccessful: boolean;
    configFilePath?: string;
    isStandaloneFileProject: boolean;
}
export declare enum CustomCommands {
    TranspileFile = "TranspileFile"
}
export declare enum NotificationName {
    busyStatus = "busyStatus"
}
