//
//  ContentView.swift
//  PomodoroTimerSwiftUIDemo
//
//  Created by Paulo Orquillo on 31/01/22.
//

import SwiftUI

struct ContentView: View {
    @State private var secondsRemaining = 1500
    @State private var minutes: CGFloat = 0
    @State private var seconds: CGFloat = 0
    @State private var milliseconds: CGFloat = 0
    //MARK: Using Timer publisher
    @State private var timer = (Timer.publish(every: 1, on: .main, in: .common).autoconnect())
    
    //MARK: To filler
    @State private var toTime: CGFloat = 0
    
    //MARK: Timer Controls
    @State private var startTimer = false
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea(.all)
 
            VStack {
                //MARK: Timer Stack
                ZStack {
                    //MARK: Circle Border
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.gray.opacity(0.6), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 280, height: 280)
                    
                    //MARK: Circle Filler
                    Circle()
                        .trim(from: 0, to: toTime)
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 280, height: 280)
                        //rotate the filler angle starts at 90 degrees - we want to start at 0
                        .rotationEffect(.init(degrees: -90))
                    
                    //MARK: Timer Counter
                    VStack(spacing: 15) {
                        Text("\(pomodoroTimeFormat(seconds: secondsRemaining))")
                            .font(.system(size: 45))
                        HStack {
                            Image(systemName: "bell")
                            Text("End Time \(estimateEndTime(seconds: secondsRemaining))")
                        }
                        .font(.subheadline)
                    }
                    .colorInvert()
                }
                //MARK: Controls
                HStack {
                    //MARK: Cancel
                    Button(action: {
                        self.startTimer = false
                        withAnimation(.default) {
                            self.seconds = 0
                            self.minutes = 0
                            self.toTime = 0
                            self.secondsRemaining = 1500
                        }
                    }) {
                        HStack(spacing: 15){
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.white)
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    //MARK: Start
                    Button(action: {
                        self.startTimer.toggle()
                    }) {
                        HStack(spacing: 15){
                            Image(systemName: self.startTimer ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            Text(startResume(startTimer: startTimer, secondsRemaining: secondsRemaining))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onReceive(self.timer) { (_) in
            if self.startTimer {
                self.seconds += 1
                self.secondsRemaining -= 1
                                
                withAnimation(.default) {
                    self.toTime = CGFloat(self.secondsRemaining) / 1500
                }
                
                if secondsRemaining == 0 {
                    print("implement notificaations")
                    self.startTimer = false
                }


            }
        }
    }
}

func startResume(startTimer: Bool, secondsRemaining: Int) -> String {
    if startTimer {
        return "Pause"
    } else {
        if secondsRemaining < 1500 && secondsRemaining > 0 {
            return "Resume"
        } else {
            return "Start"
        }
    }
}

// MARK: format seconds to minutes 25:00
func pomodoroTimeFormat(seconds : Int) -> String {
    return "\(String(format: "%02d", ((seconds % 3600) / 60))):\(String(format: "%02d", ((seconds % 3600) % 60)))"
}

func estimateEndTime(seconds: Int) -> String {
    let endDate = Date().addingTimeInterval(Double(seconds))
    let dateformat = DateFormatter()
           dateformat.dateFormat = "h:mm aa"
    return dateformat.string(from: endDate)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
