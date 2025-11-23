//
//  main.swift
//  CasePathsDemo
//
//  Created by Larry Atkin on 11/20/25.
//

import CasePaths

public protocol ChildAction: CasePathable {}

public struct Research {
    @CasePathable
    public enum ParentAction {
        case child1(Action)
        case child2(any ChildAction)
    }

    @CasePathable
    public enum Action: ChildAction {
        case somethingHappened
    }

    func test() {
        let action1CasePath: CaseKeyPath<ParentAction, Action> = \.child1
        let action2CasePath: CaseKeyPath<ParentAction, Action> = \.child2[as: HashableType(Action.self)]

        print("--- child1 ---")
        print(type(of: action1CasePath))                        // KeyPath<Case<ParentAction>, Case<Action>>
        print(action1CasePath)                                  // \Case<ParentAction>.subscript(dynamicMember: <unknown>)
        print(type(of: action1CasePath(.somethingHappened)))    // ParentAction
        print(action1CasePath(.somethingHappened))              // child1(CasePathsTest.Research.Action.somethingHappened)

        print("--- child2 ---")
        print(type(of: action2CasePath))                        // KeyPath<Case<ParentAction>, Case<Action>>
        print(action2CasePath)                                  // \Case<ParentAction>.subscript(dynamicMember: <unknown>).subscript(as: <unknown>)
        print(type(of: action2CasePath(.somethingHappened)))    // Could not cast value of type 'Action' to 'ParentAction'.
        print(action2CasePath(.somethingHappened))
    }
}

extension Case<any ChildAction> {
    subscript<T: ChildAction>(as _: HashableType<T>) -> Case<T> {
        Case<T>(embed: { $0 as any ChildAction }, extract: { $0 as? T })
    }
}

struct HashableType<T>: Hashable {
    init(_: T.Type) {}
    static func == (lhs: Self, rhs: Self) -> Bool { true }
    func hash(into hasher: inout Hasher) {}
}

Research().test()
