import type { BscType } from './BscType';
export declare class InterfaceType implements BscType {
    members: Map<string, BscType>;
    constructor(members: Map<string, BscType>);
    /**
     * The name of the interface. Can be null.
     */
    name: string;
    isAssignableTo(targetType: BscType): boolean;
    isConvertibleTo(targetType: BscType): boolean;
    toString(): string;
    toTypeString(): string;
    equals(targetType: BscType): boolean;
}
