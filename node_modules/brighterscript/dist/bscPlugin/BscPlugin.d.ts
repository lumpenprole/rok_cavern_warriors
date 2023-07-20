import type { BeforeFileTranspileEvent, CompilerPlugin, OnFileValidateEvent, OnGetCodeActionsEvent, ProvideHoverEvent, OnGetSemanticTokensEvent, OnScopeValidateEvent, ProvideCompletionsEvent } from '../interfaces';
import type { Program } from '../Program';
export declare class BscPlugin implements CompilerPlugin {
    name: string;
    onGetCodeActions(event: OnGetCodeActionsEvent): void;
    provideHover(event: ProvideHoverEvent): void;
    provideCompletions(event: ProvideCompletionsEvent): void;
    onGetSemanticTokens(event: OnGetSemanticTokensEvent): void;
    onFileValidate(event: OnFileValidateEvent): void;
    private scopeValidator;
    onScopeValidate(event: OnScopeValidateEvent): void;
    afterProgramValidate(program: Program): void;
    beforeFileTranspile(event: BeforeFileTranspileEvent): void;
}
