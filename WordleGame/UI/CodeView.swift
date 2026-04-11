//
//  CodeView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-10.
//
import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    let shouldReveal: Bool
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data Owned by Me
    @State private var isRevealed: Bool = false
    @State private var revealedCount: Int = 0
    @Namespace private var selectionNamespace
    
    init(code: Code,
         selection: Binding<Int> = .constant(-1),
         ancillaryView: @escaping () -> AncillaryView = { EmptyView() },
         shouldReveal: Bool = false)
    {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
        self.shouldReveal = shouldReveal
    }
    
    // MARK: - BODY
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                // Peg View
                PegView(peg: code.pegs[index], matchState: checkMatch(for: index), isRevealed: index < revealedCount)
                    .padding(1)
                    .background { // Selection Background
                        Group {
                            if selection == index, code.kind == .guess {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(Animation.selection, value: selection)
                    }
                    .overlay {
                        Selection.shape
                            .foregroundStyle(code.isHidden ? Color.primary : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            .onAppear {
                if shouldReveal {
                    isRevealed = true
                    revealedCount = code.pegs.count
                }
            }
            .onChange(of: shouldReveal) { oldValue, newValue in
                if newValue && !oldValue && !isRevealed {
                    startRevealIfNeeded()
                }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }
    
    func startRevealIfNeeded() -> () {
        guard shouldReveal, !isRevealed else {return}
        
        if case .attempt = code.kind {
            isRevealed = true
            Task {
                for index in code.pegs.indices {
                    withAnimation {
                        revealedCount = index + 1
                    }
                    try? await Task.sleep(for: .milliseconds(300))
                }
            }
        }
    }
    
    func checkMatch(for index: Int) -> Match? {
        if let matches = code.matches {
            return matches[index]
        } else {
            return nil
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 3
    static let cornerRadius: CGFloat = 10
    //static let color: Color = Color.gray(0.85)
    static let color: Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}
