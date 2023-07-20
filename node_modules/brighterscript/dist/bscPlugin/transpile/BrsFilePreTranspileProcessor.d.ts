import type { BrsFile } from '../../files/BrsFile';
import type { BeforeFileTranspileEvent } from '../../interfaces';
export declare class BrsFilePreTranspileProcessor {
    private event;
    constructor(event: BeforeFileTranspileEvent<BrsFile>);
    process(): void;
    private iterateExpressions;
    /**
     * Given a string optionally separated by dots, find an enum related to it.
     * For example, all of these would return the enum: `SomeNamespace.SomeEnum.SomeMember`, SomeEnum.SomeMember, `SomeEnum`
     */
    private getEnumInfo;
    private processExpression;
}
