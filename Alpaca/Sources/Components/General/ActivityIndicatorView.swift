//
//  ActivityIndicatorView.swift
//  Alpaca
//
//  Created by Lukas Mateffy on 24.03.20.
//  Copyright © 2020 Lukas Mateffy. All rights reserved.
//

//
//  ActivityIndicatorView.swift
//  ActivityIndicatorView
//
//  Created by Alisa Mylnikova on 20/03/2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI

public struct ActivityIndicatorView: View {

    public enum IndicatorType {
        case `default`
        case arcs
        case rotatingDots
        case flickeringDots
        case scalingDots
        case opacityDots
        case equalizer
        case growingArc
        case growingCircle
        case gradient([Color])
    }

    @Binding var isVisible: Bool
    var type: IndicatorType

    @State private var isAnimating: Bool = false
    @State private var parameter = 0.0

    public init(isVisible: Binding<Bool>, type: IndicatorType) {
        self._isVisible = isVisible
        self.type = type
    }

    public var body: some View {

        let indicator: AnyView
        switch type {
        case .default:
            indicator = createDefaultIndicator()
        case .arcs:
            indicator = createArcsIndicator()
        case .rotatingDots:
            indicator = createRotatingDotsIndicator()
        case .flickeringDots:
            indicator = createFlickeringDotsIndicator()
        case .scalingDots:
            indicator = createScalingDotsIndicator()
        case .opacityDots:
            indicator = createOpacityDotsIndicator()
        case .equalizer:
            indicator = createEqualizerIndicator()
        case .growingArc:
            indicator = createGrowingArcIndicator()
        case .growingCircle:
            indicator = createGrowingCircleIndicator()
        case .gradient(let colors):
            indicator = createGradientIndicator(colors: colors)
        }

        if isVisible {
            return AnyView(indicator
                .onAppear {
                    self.isAnimating = true
            }
            .onDisappear {
                self.isAnimating = false
            })
        } else {
            return AnyView(EmptyView())
        }
    }

    func createDefaultIndicator() -> AnyView {
        let count = 8
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let height = geometry.size.height / 3.2
                    let width = height / 2
                    let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
                    let x = (geometry.size.width / 2 - height / 2) * cos(angle)
                    let y = (geometry.size.height / 2 - height / 2) * sin(angle)
                    let rect = RoundedRectangle(cornerRadius: width / 2 + 1).frame(width: width, height: height)
                        .rotationEffect(Angle(radians: Double(angle + CGFloat.pi / 2)))
                        .offset(x: x, y: y)
                    return AnyView(rect
                        .opacity(!self.isAnimating ? 1 : 0.3)
                        .animation(Animation.default
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) / Double(count) / 2)
                        )
                    )
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        return AnyView(indicator)
    }

    func createArcsIndicator() -> AnyView {
        let count = 3
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> Path in
                    var p = Path()
                    p.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                             radius: geometry.size.width / 2 - CGFloat(index) * CGFloat(count),
                             startAngle: .degrees(0),
                             endAngle: .degrees(Double(Int.random(in: 120...300))),
                             clockwise: true)
                    return p.strokedPath(.init(lineWidth: 2))
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation.default
                        .speed(Double.random(in: 0.2...0.5))
                        .repeatForever(autoreverses: false))
            }
        }
        return AnyView(indicator)
    }

    func createRotatingDotsIndicator() -> AnyView {
        AnyView(GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
                        .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                        .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                        .repeatForever(autoreverses: false))
            }
        })
    }

    func createFlickeringDotsIndicator() -> AnyView {
        let count = 8
        let duration = 0.5
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let size = geometry.size.height / 5
                    let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
                    let x = (geometry.size.width / 2 - size / 2) * cos(angle)
                    let y = (geometry.size.height / 2 - size / 2) * sin(angle)
                    let circle = Circle()
                        .frame(width: size, height: size)
                        .scaleEffect(!self.isAnimating ? 1 : 0.5)
                        .opacity(!self.isAnimating ? 1 : 0.3)
                        .animation(Animation.linear(duration: duration)
                            .repeatForever(autoreverses: true)
                            .delay(duration * Double(index) / Double(count) * 2)
                        )
                        .offset(x: x, y: y)
                    return AnyView(circle)
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        return AnyView(indicator)
    }

    func createScalingDotsIndicator() -> AnyView {
        let count = 3
        let inset = 2
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let size = (geometry.size.width - CGFloat(inset) * CGFloat(count - 1)) / CGFloat(count)
                    let circle = Circle()
                        .frame(width: size, height: size)
                    return AnyView(circle
                        .scaleEffect(!self.isAnimating ? 1 : 0.3)
                        .animation(Animation.easeOut
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) / Double(count) / 2)
                    )
                        .offset(x: (size + CGFloat(inset)) * CGFloat(index) - geometry.size.width / 2 + size / 2)
                    )
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
        return AnyView(indicator)
    }

    func createOpacityDotsIndicator() -> AnyView {
        let count = 3
        let inset = 4
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let size = (geometry.size.width - CGFloat(inset) * CGFloat(count - 1)) / CGFloat(count)
                    let circle = Circle()
                        .frame(width: size, height: size)
                    return AnyView(circle
                    .scaleEffect(!self.isAnimating ? 1 : 0.9)
                        .opacity(!self.isAnimating ? 1 : 0.3)
                        .animation(Animation.easeOut
                            .repeatForever(autoreverses: true)
                            .delay(index % 2 == 0 ? 0.2 : 0)
                    )
                        .offset(x: (size + CGFloat(inset)) * CGFloat(index) - geometry.size.width / 2 + size / 2)
                    )
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
        return AnyView(indicator)
    }

    func createEqualizerIndicator() -> AnyView {
        let count = 5
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let size = geometry.size.width / CGFloat(count) / 2
                    let rect = RoundedRectangle(cornerRadius: 3)
                        .frame(width: size, height: geometry.size.height)
                    return AnyView(rect
                        .scaleEffect(x: 1, y: !self.isAnimating ? 1 : 0.4, anchor: .center)
                        .animation(Animation.easeOut
                            .delay(0.2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) / Double(count) / 2)
                    )
                        .offset(x: 2 * size * CGFloat(index) - geometry.size.width / 2 + size / 2)
                    )
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
        return AnyView(indicator)
    }

    func createGrowingArcIndicator() -> AnyView {
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            GrowingArc(p: self.parameter).stroke(Color.red, lineWidth: 4)
        }.onAppear() {
            withAnimation(Animation.easeIn(duration: 2).repeatForever(autoreverses: false)) {
                self.parameter = 1
            }
        }.onDisappear() {
            self.parameter = 0
        }

        return AnyView(indicator)
    }

    func createGrowingCircleIndicator() -> AnyView {

        let indicator = GeometryReader { (geometry: GeometryProxy) in
            Circle()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .scaleEffect(!self.isAnimating ? 0 : 1)
                .opacity(!self.isAnimating ? 1 : 0)
                .animation(Animation.easeIn(duration: 1.1)
                    .repeatForever(autoreverses: false))
        }

        return AnyView(indicator)
    }

    func createGradientIndicator(colors: [Color]) -> AnyView {
        let colors = Gradient(colors: colors)
        let conic = AngularGradient(gradient: colors, center: .center, startAngle: .zero, endAngle: .degrees(360))

        let indicator = GeometryReader { (geometry: GeometryProxy) in
            Circle()
                .strokeBorder(conic, lineWidth: 4)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                .animation(Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false))
        }

        return AnyView(indicator)
    }
}

struct GrowingArc : Shape {

    var maxLength = 2 * Double.pi - 0.7
    var lag = 0.35
    var p: Double

    var animatableData: Double {
        get { return p }
        set { p = newValue }
    }

    func path(in rect: CGRect) -> Path {

        let h = p * 2
        var length = h * maxLength
        if h > 1 && h < lag + 1 {
            length = maxLength
        }
        if h > lag + 1 {
            let coeff = 1 / (1 - lag)
            let n = h - 1 - lag
            length = (1 - n * coeff) * maxLength
        }

        let first = Double.pi / 2
        let second = 4 * Double.pi - first

        var end = h * first
        if h > 1 {
            end = first + (h - 1) * second
        }

        let start = end + length

        var p = Path()
        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(radians: start),
                 endAngle: Angle(radians: end),
                 clockwise: true)
        return p
    }
}

