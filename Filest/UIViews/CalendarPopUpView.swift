//
//  CalendarPopUpView.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-10.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit
import HorizonCalendar

class CalendarPopUpView: UIView {
    private var firstSelectedDay: Day?
    private var secondSelectedDay: Day?
    
    fileprivate func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: year+1, month: 12, day: 31))!
        //let lowerDate = calendar.date(from: DateComponents(year: 2019, month: 01, day: 20))!
        let firstSelectedDay = self.firstSelectedDay
        let secondSelectedDay = self.secondSelectedDay
        let firstSelectedDate = calendar.date(from: DateComponents(year: (firstSelectedDay?.month.year), month: (firstSelectedDay?.month.month), day: (firstSelectedDay?.day))) ?? Date.init()
        var secondSelectedDate = calendar.date(from: DateComponents(year: (secondSelectedDay?.month.year), month: (secondSelectedDay?.month.month), day: (secondSelectedDay?.day)))!
        
        if (secondSelectedDay == nil || (secondSelectedDate < firstSelectedDate)){
            secondSelectedDate = firstSelectedDate
        }
        
        let dateRangeToHighlight = firstSelectedDate...secondSelectedDate
        

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
        
        .withInterMonthSpacing(24)
        .withVerticalDayMargin(8)
        .withHorizontalDayMargin(8)
        
        .withDayRangeItemProvider(for: [dateRangeToHighlight]) { dayRangeLayoutContext in
              CalendarItem<DayRangeIndicatorView, [CGRect]>(
                 viewModel: dayRangeLayoutContext.daysAndFrames.map { $0.frame },
                styleID: "DayRangeStyle",
                buildView: { DayRangeIndicatorView() },
                updateViewModel: { dayRangeIndicatorView, dayFrames in
                  dayRangeIndicatorView.dayFrames = dayFrames
                })
        }
        
        
        .withDayItemModelProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont.systemFont(ofSize: 18),
                textColor: .darkGray,
                backgroundColor: .clear)

            if day == firstSelectedDay || day == secondSelectedDay{
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = .systemIndigo
            }

            return CalendarItemModel<DayLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
    
        }

    }

    
    fileprivate func calendarView() -> CalendarView{
        let c = CalendarView(initialContent: self.makeContent())
        c.layer.cornerRadius = 24
        c.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            
            //keeps track of days selected
            if(self.firstSelectedDay == nil){
                self.firstSelectedDay = day
            } else if (self.secondSelectedDay == nil && (day > self.firstSelectedDay!)){
                self.secondSelectedDay = day
            } else if (self.secondSelectedDay == nil && (day <= self.firstSelectedDay!)){
                self.firstSelectedDay = day
            } else {
                self.firstSelectedDay = day
                self.secondSelectedDay = nil
            }
            
            
            let newContent = self.makeContent()
            c.setContent(newContent)
        }
        
        return c
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "When will you be Absent?"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let segmentedContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 24
        return v
    }()
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let items = ["Absent", "Late"]
        let s = UISegmentedControl(items: items)
        s.selectedSegmentIndex = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 24
        return v
    }()
    
    fileprivate let selectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        button.backgroundColor = UIColor.init(red: 125/255, green:  113/255, blue:  211/255, alpha: 1.0)
        button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        button.layer.cornerRadius = 24
        
        return button
    }()
    
    fileprivate let buttonContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 24
        return v
    }()
    
    @objc fileprivate func animateShake(){
        container.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.container.transform = CGAffineTransform.identity
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor(red: 235/255, green: 23/255, blue: 23/255, alpha: 0.6)
        }, completion:nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.init(red: 125/255, green: 113/255, blue:  211/255, alpha: 0.6)
        }, completion:nil)
        
    }
    
    @objc fileprivate func animateOut(){
        if (self.firstSelectedDay == nil && self.secondSelectedDay ==  nil){
            animateShake()
        } else {
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
                self.alpha = 0
            }) { (complete) in
                if complete {
                    self.removeFromSuperview()
                }
            }
        }

    }
    
    @objc fileprivate func animateIn(){
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.titleLabel.transform = .identity
            self.alpha = 1
        })
        
    }
    
    fileprivate lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [segmentedContainer, calendarView(),buttonContainer])//selectButton
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    

    
    override init(frame: CGRect){
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.init(red: 125/255, green: 113/255, blue:  211/255, alpha: 0.6)
        self.frame = UIScreen.main.bounds
        self.addSubview(titleLabel)
        self.addSubview(container)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo:  container.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: container.rightAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(lessThanOrEqualTo: container.leftAnchor, constant: 0).isActive = true

        
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.60).isActive = true
        
        container.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: container.heightAnchor, constant: 0.0).isActive = true
        stack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        buttonContainer.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        buttonContainer.addSubview(selectButton)
        selectButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        selectButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 0.5).isActive = true
        selectButton.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor, multiplier: 0.80).isActive = true
        
        segmentedContainer.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        segmentedContainer.addSubview(segmentedControl)
        segmentedControl.centerYAnchor.constraint(equalTo: segmentedContainer.centerYAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: segmentedContainer.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: segmentedContainer.widthAnchor, multiplier: 0.5).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: segmentedContainer.heightAnchor, multiplier: 0.75).isActive = true
        
        animateIn() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DayLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
    let font: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let day: Day
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
  {
    let label = UILabel()

    label.backgroundColor = invariantViewProperties.backgroundColor
    label.font = invariantViewProperties.font
    label.textColor = invariantViewProperties.textColor

    label.textAlignment = .center
    label.clipsToBounds = true
    label.layer.cornerRadius = 12
    
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
    view.text = "\(viewModel.day.day)"
  }

}
