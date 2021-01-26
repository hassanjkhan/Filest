//
//  AbsentViewController.swift
//  Filest
//
//  Created by Hassan Khan on 2021-01-24.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import UIKit
import HorizonCalendar

class AbsentViewController: UIViewController {

    private var customView: CalendarView!
    private var selectedDay: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView = CalendarView(initialContent: makeContent())
        customView.isHidden = true
        customView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            self.selectedDay = day
            
            let newContent = self.makeContent()
            self.customView.setContent(newContent)
          }
    }
    
    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current

        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!
        
//        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: NSDate())
//        let lowerDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 20))!
//        let upperDate = calendar.date(from: DateComponents(year: 2020, month: 02, day: 07))!
//        let dateRangeToHighlight = lowerDate...upperDate
        
        let selectedDay = self.selectedDay
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
        )
            
        .withDayItemModelProvider { day in
              CalendarItemModel<DayLabel>(
                invariantViewProperties: .init(font: UIFont.systemFont(ofSize: 18),
                textColor: .darkGray, backgroundColor: .clear),
                viewModel: .init(day: day)
              )

        }
        
        .withInterMonthSpacing(24)
        .withVerticalDayMargin(8)
        .withHorizontalDayMargin(8)
        
        .withDayItemModelProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(
                font: UIFont.systemFont(ofSize: 18),
                textColor: .darkGray,
                backgroundColor: .clear)

            if day == selectedDay {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = .blue
            }

            return CalendarItemModel<DayLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
        }

    }

    
    private func loadCustomViewIntoController() {
            
            view.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.layer.cornerRadius = 15;
            customView.layer.masksToBounds = true;
        
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: 350),
                customView.heightAnchor.constraint(equalToConstant: 400),
                customView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
                customView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
            ])
            customView.isHidden = false

            // any other objects should be tied to this view as superView
            // for example adding this okayButton

            let okayButtonFrame = CGRect(x: 112, y: 340, width: 112, height: 50)
            let okayButton = UIButton(frame: okayButtonFrame)
            okayButton.setTitle("Save",for: .normal)
            okayButton.backgroundColor = UIColor(red:0.55, green:0.81, blue:0.91, alpha:1.0)
            okayButton.layer.cornerRadius = 23
            okayButton.clipsToBounds = true
     
            customView.addSubview(okayButton)
        
            NSLayoutConstraint.activate([
                okayButton.widthAnchor.constraint(equalToConstant: 100),
                okayButton.heightAnchor.constraint(equalToConstant: 50),
                okayButton.centerXAnchor.constraint(equalTo: customView.layoutMarginsGuide.centerXAnchor),
                okayButton.centerYAnchor.constraint(equalTo: customView.layoutMarginsGuide.centerYAnchor)
            ])
        
             // here we are adding the button its superView
            okayButton.addTarget(self, action: #selector(buttonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    
    @IBAction func dateButton(_ sender: UIButton) {
        // this barButton is located at the top of your tableview navigation bar
        // when it pressed make sure you remove any other activities that were on the screen, for example dismiss a keyboard
          loadCustomViewIntoController()
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        customView.isHidden = true
    }
}



/*
 
    CalendarItemModel is a type that abstracts away the creation and configuration of a UIView. It's generic over a ViewRepresentable type, which can be any type conforming to         CalendarItemViewRepresentable. You can think of CalendarItemViewRepresentable as a blueprint for creating and updating instances of a particular type of view to be displayed in the calendar. For example, if we want to use a UILabel for our custom day view, we'll need to create a type that knows how to create and update that label. Here's a simple example:

*/
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


