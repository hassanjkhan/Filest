
import UIKit
import HorizonCalendar

final class DayRangeIndicatorView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  var dayFrames = [CGRect]() {
    didSet {
      guard dayFrames != oldValue else { return }
      setNeedsDisplay()
    }
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(UIColor.systemIndigo.withAlphaComponent(0.30).cgColor)

    // Get frames of day rows in the range
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in dayFrames {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }

    // Draw rounded rectangles for each day row
    for dayRowFrame in dayRowFrames {
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: 12)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }

}



