//
// Star rating control written in Swift for iOS.
//
// https://github.com/marketplacer/Cosmos
//
// This file was automatically generated by combining multiple Swift source files.
//


// ----------------------------
//
// CosmosAccessibility.swift
//
// ----------------------------

import UIKit

/**

Functions for making cosmos view accessible.

*/
struct CosmosAccessibility {
  /**

  Makes the view accesible by settings its label and using rating as value.

  */

  static func update(_ view: UIView, rating: Double, text: String?, settings: CosmosSettings) {
    view.isAccessibilityElement = true

    view.accessibilityTraits = settings.updateOnTouch ?
      UIAccessibilityTraitAdjustable :UIAccessibilityTraitNone

    var accessibilityLabel = CosmosLocalizedRating.ratingTranslation

    if let text = text , text != "" {
      accessibilityLabel += " \(text)"
    }

    view.accessibilityLabel = accessibilityLabel

    view.accessibilityValue = accessibilityValue(view, rating: rating, settings: settings)
  }

  /**

  Returns the rating that is used as accessibility value.
  The accessibility value depends on the star fill mode.

  For example, if rating is 4.6 and fill mode is .Half the value will be 4.5. And if the fill mode
  if .Full the value will be 5.

  */
  static func accessibilityValue(_ view: UIView, rating: Double, settings: CosmosSettings) -> String {
    let accessibilityRating = CosmosRating.displayedRatingFromPreciseRating(rating,
      fillMode: settings.fillMode, totalStars: settings.totalStars)

    // Omit decimals if the value is an integer
    let isInteger = (accessibilityRating * 10).truncatingRemainder(dividingBy: 10) == 0

    if isInteger {
      return "\(Int(accessibilityRating))"
    } else {
      // Only show a single decimal place
      let roundedToFirstDecimalPlace = Double( round(10 * accessibilityRating) / 10 )
      return "\(roundedToFirstDecimalPlace)"
    }
  }

  /**

  Returns the amount of increment for the rating. When .Half and .Precise fill modes are used the
  rating is incremented by 0.5.

  */
  static func accessibilityIncrement(_ rating: Double, settings: CosmosSettings) -> Double {
    var increment: Double = 0

    switch settings.fillMode {
    case .full:
      increment = ceil(rating) - rating
      if increment == 0 { increment = 1 }

    case .half, .precise:
      increment = (ceil(rating * 2) - rating * 2) / 2
      if increment == 0 { increment = 0.5 }
    }

    if rating >= Double(settings.totalStars) { increment = 0 }

    return increment
  }

  static func accessibilityDecrement(_ rating: Double, settings: CosmosSettings) -> Double {
    var increment: Double = 0

    switch settings.fillMode {
    case .full:
      increment = rating - floor(rating)
      if increment == 0 { increment = 1 }

    case .half, .precise:
      increment = (rating * 2 - floor(rating * 2)) / 2
      if increment == 0 { increment = 0.5 }
    }

    if rating <= settings.minTouchRating { increment = 0 }

    return increment
  }
}


// ----------------------------
//
// CosmosDefaultSettings.swift
//
// ----------------------------

import UIKit

/**

Defaults setting values.

*/
struct CosmosDefaultSettings {
  init() {}

  static let defaultColor = UIColor(red: 1, green: 149/255, blue: 0, alpha: 1)


  // MARK: - Star settings
  // -----------------------------

  /// Border color of an empty star.
  static let emptyBorderColor = defaultColor

  /// Width of the border for the empty star.
  static let emptyBorderWidth: Double = 1 / Double(UIScreen.main.scale)

  /// Border color of a filled star.
  static let filledBorderColor = defaultColor

  /// Width of the border for a filled star.
  static let filledBorderWidth: Double = 1 / Double(UIScreen.main.scale)

  /// Background color of an empty star.
  static let emptyColor = UIColor.clear

  /// Background color of a filled star.
  static let filledColor = defaultColor

  /**

  Defines how the star is filled when the rating value is not an integer value. It can either show full stars, half stars or stars partially filled according to the rating value.

  */
  static let fillMode = StarFillMode.full

  /// Rating value that is shown in the storyboard by default.
  static let rating: Double = 2.718281828

  /// Distance between stars.
  static let starMargin: Double = 5

  /**

  Array of points for drawing the star with size of 100 by 100 pixels. Supply your points if you need to draw a different shape.

  */
  static let starPoints: [CGPoint] = [
    CGPoint(x: 49.5, y: 0.0),
    CGPoint(x: 60.5, y: 35.0),
    CGPoint(x: 99.0, y: 35.0),
    CGPoint(x: 67.5, y: 58.0),
    CGPoint(x: 78.5, y: 92.0),
    CGPoint(x: 49.5, y: 71.0),
    CGPoint(x: 20.5, y: 92.0),
    CGPoint(x: 31.5, y: 58.0),
    CGPoint(x: 0.0, y: 35.0),
    CGPoint(x: 38.5, y: 35.0)
  ]

  /// Size of a single star.
  static var starSize: Double = 20

  /// The total number of stars to be shown.
  static let totalStars = 5


  // MARK: - Text settings
  // -----------------------------


  /// Color of the text.
  static let textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)

  /// Font for the text.
  static let textFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)

  /// Distance between the text and the stars.
  static let textMargin: Double = 5

  /// Calculates the size of the default text font. It is used for making the text size configurable from the storyboard.
  static var textSize: Double {
    get {
      return Double(textFont.pointSize)
    }
  }


  // MARK: - Touch settings
  // -----------------------------

  /// The lowest rating that user can set by touching the stars.
  static let minTouchRating: Double = 1

  /// When `true` the star fill level is updated when user touches the cosmos view. When `false` the Cosmos view only shows the rating and does not act as the input control.
  static let updateOnTouch = true
}


// ----------------------------
//
// CosmosLayerHelper.swift
//
// ----------------------------

import UIKit

/// Helper class for creating CALayer objects.
class CosmosLayerHelper {
  /**

  Creates a text layer for the given text string and font.

  - parameter text: The text shown in the layer.
  - parameter font: The text font. It is also used to calculate the layer bounds.
  - parameter color: Text color.

  - returns: New text layer.

  */
  class func createTextLayer(_ text: String, font: UIFont, color: UIColor) -> CATextLayer {
    let size = NSString(string: text).size(withAttributes: [NSAttributedStringKey.font: font])
    
    let layer = CATextLayer()
    layer.bounds = CGRect(origin: CGPoint(), size: size)
    layer.anchorPoint = CGPoint()
    layer.font = CGFont(font.fontName as CFString)
    layer.fontSize = font.pointSize
    layer.foregroundColor = color.cgColor
    layer.contentsScale = UIScreen.main.scale

    return layer
  }
}


// ----------------------------
//
// CosmosLayers.swift
//
// ----------------------------

import UIKit


/**

Colection of helper functions for creating star layers.

*/
class CosmosLayers {
  /**

  Creates the layers for the stars.

  - parameter rating: The decimal number representing the rating. Usually a number between 1 and 5
  - parameter settings: Star view settings.
  - returns: Array of star layers.

  */
  class func createStarLayers(_ rating: Double, settings: CosmosSettings) -> [CALayer] {

    var ratingRemander = CosmosRating.numberOfFilledStars(rating,
      totalNumberOfStars: settings.totalStars)

    var starLayers = [CALayer]()

    for _ in (0..<settings.totalStars) {

      let fillLevel = CosmosRating.starFillLevel(ratingRemainder: ratingRemander,
        fillMode: settings.fillMode)

      let starLayer = createCompositeStarLayer(fillLevel, settings: settings)
      starLayers.append(starLayer)
      ratingRemander -= 1
    }

    positionStarLayers(starLayers, starMargin: settings.starMargin)
    return starLayers
  }


  /**

  Creates an layer that shows a star that can look empty, fully filled or partially filled.
  Partially filled layer contains two sublayers.

  - parameter starFillLevel: Decimal number between 0 and 1 describing the star fill level.
  - parameter settings: Star view settings.
  - returns: Layer that shows the star. The layer is displauyed in the cosmos view.

  */
  class func createCompositeStarLayer(_ starFillLevel: Double, settings: CosmosSettings) -> CALayer {

    if starFillLevel >= 1 {
      return createStarLayer(true, settings: settings)
    }

    if starFillLevel == 0 {
      return createStarLayer(false, settings: settings)
    }

    return createPartialStar(starFillLevel, settings: settings)
  }

  /**

  Creates a partially filled star layer with two sub-layers:

  1. The layer for the filled star on top. The fill level parameter determines the width of this layer.
  2. The layer for the empty star below.

  - parameter starFillLevel: Decimal number between 0 and 1 describing the star fill level.
  - parameter settings: Star view settings.

  - returns: Layer that contains the partially filled star.

  */
  class func createPartialStar(_ starFillLevel: Double, settings: CosmosSettings) -> CALayer {
    let filledStar = createStarLayer(true, settings: settings)
    let emptyStar = createStarLayer(false, settings: settings)

    let parentLayer = CALayer()
    parentLayer.contentsScale = UIScreen.main.scale
    parentLayer.bounds = CGRect(origin: CGPoint(), size: filledStar.bounds.size)
    parentLayer.anchorPoint = CGPoint()
    parentLayer.addSublayer(emptyStar)
    parentLayer.addSublayer(filledStar)

    // make filled layer width smaller according to the fill level.
    filledStar.bounds.size.width *= CGFloat(starFillLevel)

    return parentLayer
  }

  fileprivate class func createStarLayer(_ isFilled: Bool, settings: CosmosSettings) -> CALayer {
    let fillColor = isFilled ? settings.filledColor : settings.emptyColor
    let strokeColor = isFilled ? settings.filledBorderColor : settings.emptyBorderColor

    return StarLayer.create(settings.starPoints,
      size: settings.starSize,
      lineWidth: isFilled ? settings.filledBorderWidth : settings.emptyBorderWidth,
      fillColor: fillColor,
      strokeColor: strokeColor)
  }

  /**

  Positions the star layers one after another with a margin in between.

  - parameter layers: The star layers array.
  - parameter starMargin: Margin between stars.

  */
  class func positionStarLayers(_ layers: [CALayer], starMargin: Double) {
    var positionX: CGFloat = 0

    for layer in layers {
      layer.position.x = positionX
      positionX += layer.bounds.width + CGFloat(starMargin)
    }
  }
}


// ----------------------------
//
// CosmosLocalizedRating.swift
//
// ----------------------------

import Foundation

/**

Returns the word "Rating" in user's language. It is used for voice-over  in accessibility mode.

*/
struct CosmosLocalizedRating {
  static var defaultText = "Rating"

  static var localizedRatings = [
    "ar": "تصنيف",
    "bg": "Рейтинг",
    "cy": "Sgôr",
    "da": "Rating",
    "de": "Bewertung",
    "el": "Βαθμολογία",
    "en": defaultText,
    "es": "Valorar",
    "et": "Reiting",
    "fi": "Luokitus",
    "fr": "De note",
    "he": "דירוג",
    "hi": "रेटिंग",
    "hr": "Ocjena",
    "hu": "Értékelés",
    "id": "Peringkat",
    "it": "Voto",
    "ko": "등급",
    "lt": "Reitingas",
    "lv": "Vērtējums",
    "nl": "Rating",
    "no": "Vurdering",
    "pl": "Ocena",
    "pt": "Classificação",
    "ro": "Evaluare",
    "ru": "Рейтинг",
    "sk": "Hodnotenie",
    "sl": "Ocena",
    "sr": "Рејтинг",
    "sw": "Rating",
    "th": "การจัดอันดับ",
    "tr": "Oy verin",
    "cs": "Hodnocení",
    "uk": "Рейтинг",
    "vi": "Đánh giá",
    "zh": "评分"
  ]

  static var ratingTranslation: String {
    let languages = preferredLanguages(NSLocale.preferredLanguages)
    return ratingInPreferredLanguage(languages)
  }

  /**

  Returns the word "Rating" in user's language.

  - parameter language: ISO 639-1 language code. Example: 'en'.

  */
  static func translation(_ language: String) -> String? {
    return localizedRatings[language]
  }

  /**

  Returns translation using the preferred language.

  - parameter preferredLanguages: Array of preferred language codes (ISO 639-1). The first element is most preferred.

  - parameter localizedText: Dictionary with translations for the languages. The keys are ISO 639-1 language codes and values are the text.

  - parameter fallbackTranslation: The translation text used if no translation found for the preferred languages.

  - returns: Translation for the preferred language.

  */
  static func translationInPreferredLanguage(_ preferredLanguages: [String],
    localizedText: [String: String],
    fallbackTranslation: String) -> String {

    for language in preferredLanguages {
      if let translatedText = translation(language) {
        return translatedText
      }
    }

    return fallbackTranslation
  }

  static func ratingInPreferredLanguage(_ preferredLanguages: [String]) -> String {
    return translationInPreferredLanguage(preferredLanguages,
      localizedText: localizedRatings,
      fallbackTranslation: defaultText)
  }

  static func preferredLanguages(_ preferredLocales: [String]) -> [String] {
    return preferredLocales.map { element in

      let dashSeparated = element.components(separatedBy: "-")
      if dashSeparated.count > 1 { return dashSeparated[0] }

      let underscoreSeparated = element.components(separatedBy: "_")
      if underscoreSeparated.count > 1 { return underscoreSeparated[0] }

      return element
    }
  }
}


// ----------------------------
//
// CosmosRating.swift
//
// ----------------------------

import UIKit

/**

Helper functions for calculating rating.

*/
struct CosmosRating {

  /**

  Returns a decimal number between 0 and 1 describing the star fill level.

  - parameter ratingRemainder: This value is passed from the loop that creates star layers. The value starts with the rating value and decremented by 1 when each star is created. For example, suppose we want to display rating of 3.5. When the first star is created the ratingRemainder parameter will be 3.5. For the second star it will be 2.5. Third: 1.5. Fourth: 0.5. Fifth: -0.5.

  - parameter fillMode: Describe how stars should be filled: full, half or precise.

  - returns: Decimal value between 0 and 1 describing the star fill level. 1 is a fully filled star. 0 is an empty star. 0.5 is a half-star.

  */
  static func starFillLevel(ratingRemainder: Double, fillMode: StarFillMode) -> Double {

    var result = ratingRemainder

    if result > 1 { result = 1 }
    if result < 0 { result = 0 }

    return roundFillLevel(result, fillMode: fillMode)
  }

  /**

  Rounds a single star's fill level according to the fill mode. "Full" mode returns 0 or 1 by using the standard decimal rounding. "Half" mode returns 0, 0.5 or 1 by rounding the decimal to closest of 3 values. "Precise" mode will return the fill level unchanged.

  - parameter starFillLevel: Decimal number between 0 and 1 describing the star fill level.

  - parameter fillMode: Fill mode that is used to round the fill level value.

  - returns: The rounded fill level.

  */
  static func roundFillLevel(_ starFillLevel: Double, fillMode: StarFillMode) -> Double {
    switch fillMode {
    case .full:
      return Double(round(starFillLevel))
    case .half:
      return Double(round(starFillLevel * 2) / 2)
    case .precise :
      return starFillLevel
    }
  }


  /**

  Helper function for calculating the rating that is displayed to the user
  taking into account the star fill mode. For example, if the fill mode is .Half and precise rating is 4.6, the displayed rating will be 4.5. And if the fill mode is .Full the displayed rating will be 5.

  - parameter preciseRating: Precise rating value, like 4.8237

  - parameter fillMode: Describe how stars should be filled: full, half or precise.

  - parameter totalStars: Total number of stars.

  - returns: Returns rating that is displayed to the user taking into account the star fill mode.

  */
  static func displayedRatingFromPreciseRating(_ preciseRating: Double,
    fillMode: StarFillMode, totalStars: Int) -> Double {

    let starFloorNumber = floor(preciseRating)
    let singleStarRemainder = preciseRating - starFloorNumber

    var displayedRating = starFloorNumber + starFillLevel(
      ratingRemainder: singleStarRemainder, fillMode: fillMode)

    displayedRating = min(Double(totalStars), displayedRating) // Can't go bigger than number of stars
    displayedRating = max(0, displayedRating) // Can't be less than zero

    return displayedRating
  }

  /**

  Returns the number of filled stars for given rating.

  - parameter rating: The rating to be displayed.
  - parameter totalNumberOfStars: Total number of stars.
  - returns: Number of filled stars. If rating is biggen than the total number of stars (usually 5) it returns the maximum number of stars.

  */
  static func numberOfFilledStars(_ rating: Double, totalNumberOfStars: Int) -> Double {
    if rating > Double(totalNumberOfStars) { return Double(totalNumberOfStars) }
    if rating < 0 { return 0 }

    return rating
  }
}


// ----------------------------
//
// CosmosSettings.swift
//
// ----------------------------

import UIKit

/**

Settings that define the appearance of the star rating views.

*/
public struct CosmosSettings {
  init() {}

  // MARK: - Star settings
  // -----------------------------

  /// Border color of an empty star.
  public var emptyBorderColor = CosmosDefaultSettings.emptyBorderColor

  /// Width of the border for empty star.
  public var emptyBorderWidth: Double = CosmosDefaultSettings.emptyBorderWidth

  /// Border color of a filled star.
  public var filledBorderColor = CosmosDefaultSettings.filledBorderColor

  /// Width of the border for a filled star.
  public var filledBorderWidth: Double = CosmosDefaultSettings.filledBorderWidth

  /// Background color of an empty star.
  public var emptyColor = CosmosDefaultSettings.emptyColor

  /// Background color of a filled star.
  public var filledColor = CosmosDefaultSettings.filledColor

  /**

  Defines how the star is filled when the rating value is not a whole integer. It can either show full stars, half stars or stars partially filled according to the rating value.

  */
  public var fillMode = CosmosDefaultSettings.fillMode

  /// Distance between stars.
  public var starMargin: Double = CosmosDefaultSettings.starMargin

  /**

  Array of points for drawing the star with size of 100 by 100 pixels. Supply your points if you need to draw a different shape.

  */
  public var starPoints: [CGPoint] = CosmosDefaultSettings.starPoints

  /// Size of a single star.
  public var starSize: Double = CosmosDefaultSettings.starSize

  /// The maximum number of stars to be shown.
  public var totalStars = CosmosDefaultSettings.totalStars


  // MARK: - Text settings
  // -----------------------------

  /// Color of the text.
  public var textColor = CosmosDefaultSettings.textColor

  /// Font for the text.
  public var textFont = CosmosDefaultSettings.textFont

  /// Distance between the text and the stars.
  public var textMargin: Double = CosmosDefaultSettings.textMargin


  // MARK: - Touch settings
  // -----------------------------

  /// The lowest rating that user can set by touching the stars.
  public var minTouchRating: Double = CosmosDefaultSettings.minTouchRating

  /// When `true` the star fill level is updated when user touches the cosmos view. When `false` the Cosmos view only shows the rating and does not act as the input control.
  public var updateOnTouch = CosmosDefaultSettings.updateOnTouch
}


// ----------------------------
//
// CosmosSize.swift
//
// ----------------------------

import UIKit

/**

Helper class for calculating size for the cosmos view.

*/
class CosmosSize {
  /**

  Calculates the size of the cosmos view. It goes through all the star and text layers and makes size the view size is large enough to show all of them.

  */
  class func calculateSizeToFitLayers(_ layers: [CALayer]) -> CGSize {
    var size = CGSize()

    for layer in layers {
      if layer.frame.maxX > size.width {
        size.width = layer.frame.maxX
      }

      if layer.frame.maxY > size.height {
        size.height = layer.frame.maxY
      }
    }

    return size
  }
}


// ----------------------------
//
// CosmosText.swift
//
// ----------------------------



import UIKit

/**

Positions the text layer to the right of the stars.

*/
class CosmosText {
  /**

  Positions the text layer to the right from the stars. Text is aligned to the center of the star superview vertically.

  - parameter layer: The text layer to be positioned.
  - parameter starsSize: The size of the star superview.
  - parameter textMargin: The distance between the stars and the text.

  */
  class func position(_ layer: CALayer, starsSize: CGSize, textMargin: Double) {
    layer.position.x = starsSize.width + CGFloat(textMargin)
    let yOffset = (starsSize.height - layer.bounds.height) / 2
    layer.position.y = yOffset
  }
}


// ----------------------------
//
// CosmosTouch.swift
//
// ----------------------------

import UIKit

/**

Functions for working with touch input.

*/
struct CosmosTouch {
  /**

  Calculates the rating based on the touch location.

  - parameter locationX: The horizontal location of the touch relative to the width of the stars.

  - parameter starsWidth: The width of the stars excluding the text.

  - returns: The rating representing the touch location.

  */
  static func touchRating(_ locationX: CGFloat, starsWidth: CGFloat, settings: CosmosSettings) -> Double {

    let position = locationX / starsWidth
    let totalStars = Double(settings.totalStars)
    let actualRating = totalStars * Double(position)
    var correctedRating = actualRating

    if settings.fillMode != .precise {
      correctedRating += 0.25
    }

    correctedRating = CosmosRating.displayedRatingFromPreciseRating(correctedRating,
      fillMode: settings.fillMode, totalStars: settings.totalStars)

    correctedRating = max(settings.minTouchRating, correctedRating) // Can't be less than min rating

    return correctedRating
  }
}


// ----------------------------
//
// CosmosView.swift
//
// ----------------------------

import UIKit

/**

A star rating view that can be used to show customer rating for the products. On can select stars by tapping on them when updateOnTouch settings is true. An optional text can be supplied that is shown on the right side.

Example:

    cosmosView.rating = 4
    cosmosView.text = "(123)"

Shows: ★★★★☆ (132)

*/
@IBDesignable open class CosmosView: UIView {

  /**

  The currently shown number of stars, usually between 1 and 5. If the value is decimal the stars will be shown according to the Fill Mode setting.

  */
  @IBInspectable open var rating: Double = CosmosDefaultSettings.rating {
    didSet {
      if oldValue != rating {
        update()
      }
    }
  }

  /// Currently shown text. Set it to nil to display just the stars without text.
  @IBInspectable open var text: String? {
    didSet {
      if oldValue != text {
        update()
      }
    }
  }

  /// Star rating settings.
  open var settings = CosmosSettings() {
    didSet {
      update()
    }
  }

  /// Stores calculated size of the view. It is used as intrinsic content size.
  fileprivate var viewSize = CGSize()

  /// Draws the stars when the view comes out of storyboard with default settings
  open override func awakeFromNib() {
    super.awakeFromNib()

    update()
  }


  /**

  Initializes and returns a newly allocated cosmos view object.

  */
  convenience public init() {
    self.init(frame: CGRect())
  }

  /**

  Initializes and returns a newly allocated cosmos view object with the specified frame rectangle.

  - parameter frame: The frame rectangle for the view.

  */
  override public init(frame: CGRect) {
    super.init(frame: frame)
    update()
    self.frame.size = intrinsicContentSize

    improvePerformance()
  }

  /// Initializes and returns a newly allocated cosmos view object.
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    improvePerformance()
  }

  /// Change view settings for faster drawing
  fileprivate func improvePerformance() {
    /// Cache the view into a bitmap instead of redrawing the stars each time
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale

    isOpaque = true
  }

  /**

  Updates the stars and optional text based on current values of `rating` and `text` properties.

  */
  open func update() {

    // Create star layers
    // ------------

    var layers = CosmosLayers.createStarLayers(rating, settings: settings)
    layer.sublayers = layers

    // Create text layer
    // ------------

    if let text = text {
      let textLayer = createTextLayer(text, layers: layers)
      layers.append(textLayer)
    }

    // Update size
    // ------------

    updateSize(layers)

    // Update accesibility
    // ------------

    updateAccessibility()
  }

  /**

  Creates the text layer for the given text string.

  - parameter text: Text string for the text layer.
  - parameter layers: Arrays of layers containing the stars.

  - returns: The newly created text layer.

  */
  fileprivate func createTextLayer(_ text: String, layers: [CALayer]) -> CALayer {
    let textLayer = CosmosLayerHelper.createTextLayer(text,
      font: settings.textFont, color: settings.textColor)

    let starsSize = CosmosSize.calculateSizeToFitLayers(layers)

    CosmosText.position(textLayer, starsSize: starsSize, textMargin: settings.textMargin)

    layer.addSublayer(textLayer)

    return textLayer
  }

  /**

  Updates the size to fit all the layers containing stars and text.

  - parameter layers: Array of layers containing stars and the text.

  */
  fileprivate func updateSize(_ layers: [CALayer]) {
    viewSize = CosmosSize.calculateSizeToFitLayers(layers)
    invalidateIntrinsicContentSize()
  }

  /// Returns the content size to fit all the star and text layers.
    override open var intrinsicContentSize: CGSize {
    return viewSize
  }

  // MARK: - Accessibility

  fileprivate func updateAccessibility() {
    CosmosAccessibility.update(self, rating: rating, text: text, settings: settings)
  }

  /// Called by the system in accessibility voice-over mode when the value is incremented by the user.
  open override func accessibilityIncrement() {
    super.accessibilityIncrement()

    rating += CosmosAccessibility.accessibilityIncrement(rating, settings: settings)
    didTouchCosmos?(rating)
    didFinishTouchingCosmos?(rating)
  }

  /// Called by the system in accessibility voice-over mode when the value is decremented by the user.
  open override func accessibilityDecrement() {
    super.accessibilityDecrement()

    rating -= CosmosAccessibility.accessibilityDecrement(rating, settings: settings)
    didTouchCosmos?(rating)
    didFinishTouchingCosmos?(rating)
  }

  // MARK: - Touch recognition

  /// Closure will be called when user touches the cosmos view. The touch rating argument is passed to the closure.
  open var didTouchCosmos: ((Double)->())?

  /// Closure will be called when the user lifts finger from the cosmos view. The touch rating argument is passed to the closure.
  open var didFinishTouchingCosmos: ((Double)->())?

  /// Overriding the function to detect the first touch gesture.
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    if let touch = touches.first {
      let location = touch.location(in: self).x
      onDidTouch(location, starsWidth: widthOfStars)
    }
  }

  /// Overriding the function to detect touch move.
  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)

    if let touch = touches.first {
      let location = touch.location(in: self).x
      onDidTouch(location, starsWidth: widthOfStars)
    }
  }

  /// Detecting event when the user lifts their finger.
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    didFinishTouchingCosmos?(rating)
  }

  /**

  Called when the view is touched.

  - parameter locationX: The horizontal location of the touch relative to the width of the stars.

  - parameter starsWidth: The width of the stars excluding the text.

  */
  func onDidTouch(_ locationX: CGFloat, starsWidth: CGFloat) {
    let calculatedTouchRating = CosmosTouch.touchRating(locationX, starsWidth: starsWidth,
      settings: settings)

    if settings.updateOnTouch {
      rating = calculatedTouchRating
    }

    if calculatedTouchRating == previousRatingForDidTouchCallback {
      // Do not call didTouchCosmos if rating has not changed
      return
    }

    didTouchCosmos?(calculatedTouchRating)
    previousRatingForDidTouchCallback = calculatedTouchRating
  }

  fileprivate var previousRatingForDidTouchCallback: Double = -123.192


  /// Width of the stars (excluding the text). Used for calculating touch location.
  var widthOfStars: CGFloat {
    if let sublayers = self.layer.sublayers , settings.totalStars <= sublayers.count {
      let starLayers = Array(sublayers[0..<settings.totalStars])
      return CosmosSize.calculateSizeToFitLayers(starLayers).width
    }

    return 0
  }

  /// Increase the hitsize of the view if it's less than 44px for easier touching.
  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let oprimizedBounds = CosmosTouchTarget.optimize(bounds)
    return oprimizedBounds.contains(point)
  }


  // MARK: - Properties inspectable from the storyboard

  @IBInspectable var totalStars: Int = CosmosDefaultSettings.totalStars {
    didSet {
      settings.totalStars = totalStars
    }
  }

  @IBInspectable var starSize: Double = CosmosDefaultSettings.starSize {
    didSet {
      settings.starSize = starSize
    }
  }

  @IBInspectable var filledColor: UIColor = CosmosDefaultSettings.filledColor {
    didSet {
      settings.filledColor = filledColor
    }
  }

  @IBInspectable var emptyColor: UIColor = CosmosDefaultSettings.emptyColor {
    didSet {
      settings.emptyColor = emptyColor
    }
    }

    @IBInspectable var emptyBorderColor: UIColor = CosmosDefaultSettings.emptyBorderColor {
        didSet {
            settings.emptyBorderColor = emptyBorderColor
        }
    }

    @IBInspectable var emptyBorderWidth: Double = CosmosDefaultSettings.emptyBorderWidth {
        didSet {
            settings.emptyBorderWidth = emptyBorderWidth
        }
    }

    @IBInspectable var filledBorderColor: UIColor = CosmosDefaultSettings.filledBorderColor {
        didSet {
            settings.filledBorderColor = filledBorderColor
        }
    }

    @IBInspectable var filledBorderWidth: Double = CosmosDefaultSettings.filledBorderWidth {
        didSet {
            settings.filledBorderWidth = filledBorderWidth
        }
    }

  @IBInspectable var starMargin: Double = CosmosDefaultSettings.starMargin {
    didSet {
      settings.starMargin = starMargin
    }
  }

  @IBInspectable var fillMode: Int = CosmosDefaultSettings.fillMode.rawValue {
    didSet {
      settings.fillMode = StarFillMode(rawValue: fillMode) ?? CosmosDefaultSettings.fillMode
    }
  }

  @IBInspectable var textSize: Double = CosmosDefaultSettings.textSize {
    didSet {
      settings.textFont = settings.textFont.withSize(CGFloat(textSize))
    }
  }

  @IBInspectable var textMargin: Double = CosmosDefaultSettings.textMargin {
    didSet {
      settings.textMargin = textMargin
    }
  }

  @IBInspectable var textColor: UIColor = CosmosDefaultSettings.textColor {
    didSet {
      settings.textColor = textColor
    }
  }

  @IBInspectable var updateOnTouch: Bool = CosmosDefaultSettings.updateOnTouch {
    didSet {
      settings.updateOnTouch = updateOnTouch
    }
  }

  @IBInspectable var minTouchRating: Double = CosmosDefaultSettings.minTouchRating {
    didSet {
      settings.minTouchRating = minTouchRating
    }
  }

  /// Draw the stars in interface buidler
  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    update()
  }
}


// ----------------------------
//
// CosmosTouchTarget.swift
//
// ----------------------------

import UIKit

/**

Helper function to make sure bounds are big enought to be used as touch target.
The function is used in pointInside(point: CGPoint, withEvent event: UIEvent?) of UIImageView.

*/
struct CosmosTouchTarget {
  static func optimize(_ bounds: CGRect) -> CGRect {
    let recommendedHitSize: CGFloat = 44

    var hitWidthIncrease: CGFloat = recommendedHitSize - bounds.width
    var hitHeightIncrease: CGFloat = recommendedHitSize - bounds.height

    if hitWidthIncrease < 0 { hitWidthIncrease = 0 }
    if hitHeightIncrease < 0 { hitHeightIncrease = 0 }

    let extendedBounds: CGRect = bounds.insetBy(dx: -hitWidthIncrease / 2,
      dy: -hitHeightIncrease / 2)

    return extendedBounds
  }
}


// ----------------------------
//
// StarFillMode.swift
//
// ----------------------------

import Foundation

/**

Defines how the star is filled when the rating is not an integer number. For example, if rating is 4.6 and the fill more is Half, the star will appear to be half filled.

*/
public enum StarFillMode: Int {
  /// Show only fully filled stars. For example, fourth star will be empty for 3.2.
  case full = 0

  /// Show fully filled and half-filled stars. For example, fourth star will be half filled for 3.6.
  case half = 1

  /// Fill star according to decimal rating. For example, fourth star will be 20% filled for 3.2.
  case precise = 2
}


// ----------------------------
//
// StarLayer.swift
//
// ----------------------------

import UIKit

/**

Creates a layer with a single star in it.

*/
struct StarLayer {
  /**

  Creates a square layer with given size and draws the star shape in it.

  - parameter starPoints: Array of points for drawing a closed shape. The size of enclosing rectangle is 100 by 100.

  - parameter size: The width and height of the layer. The star shape is scaled to fill the size of the layer.

  - parameter lineWidth: The width of the star stroke.

  - parameter fillColor: Star shape fill color. Fill color is invisible if it is a clear color.

  - parameter strokeColor: Star shape stroke color. Stroke is invisible if it is a clear color.

  - returns: New layer containing the star shape.

  */
  static func create(_ starPoints: [CGPoint], size: Double,
    lineWidth: Double, fillColor: UIColor, strokeColor: UIColor) -> CALayer {

    let containerLayer = createContainerLayer(size)
    let path = createStarPath(starPoints, size: size, lineWidth: lineWidth)

    let shapeLayer = createShapeLayer(path.cgPath, lineWidth: lineWidth,
      fillColor: fillColor, strokeColor: strokeColor, size: size)

    containerLayer.addSublayer(shapeLayer)

    return containerLayer
  }

  /**

  Creates the star shape layer.

  - parameter path: The star shape path.

  - parameter lineWidth: The width of the star stroke.

  - parameter fillColor: Star shape fill color. Fill color is invisible if it is a clear color.

  - parameter strokeColor: Star shape stroke color. Stroke is invisible if it is a clear color.

  - returns: New shape layer.

  */
  static func createShapeLayer(_ path: CGPath, lineWidth: Double, fillColor: UIColor,
    strokeColor: UIColor, size: Double) -> CALayer {

    let layer = CAShapeLayer()
    layer.anchorPoint = CGPoint()
    layer.contentsScale = UIScreen.main.scale
    layer.strokeColor = strokeColor.cgColor
    layer.fillColor = fillColor.cgColor
    layer.lineWidth = CGFloat(lineWidth)
    layer.bounds.size = CGSize(width: size, height: size)
    layer.masksToBounds = true
    layer.path = path
    layer.isOpaque = true
    return layer
  }

  /**

  Creates a layer that will contain the shape layer.

  - returns: New container layer.

  */
  static func createContainerLayer(_ size: Double) -> CALayer {
    let layer = CALayer()
    layer.contentsScale = UIScreen.main.scale
    layer.anchorPoint = CGPoint()
    layer.masksToBounds = true
    layer.bounds.size = CGSize(width: size, height: size)
    layer.isOpaque = true
    return layer
  }

  /**

  Creates a path for the given star points and size. The star points specify a shape of size 100 by 100. The star shape will be scaled if the size parameter is not 100. For exampe, if size parameter is 200 the shape will be scaled by 2.

  - parameter starPoints: Array of points for drawing a closed shape. The size of enclosing rectangle is 100 by 100.

  - parameter size: Specifies the size of the shape to return.

  - returns: New shape path.

  */
  static func createStarPath(_ starPoints: [CGPoint], size: Double,
                             lineWidth: Double) -> UIBezierPath {

    let lineWidthLocal = lineWidth + ceil(lineWidth * 0.3)
    let sizeWithoutLineWidth = size - lineWidthLocal * 2

    let points = scaleStar(starPoints, factor: sizeWithoutLineWidth / 100,
                           lineWidth: lineWidthLocal)

    let path = UIBezierPath()
    path.move(to: points[0])
    let remainingPoints = Array(points[1..<points.count])

    for point in remainingPoints {
      path.addLine(to: point)
    }

    path.close()
    return path
  }

  /**

  Scale the star points by the given factor.

  - parameter starPoints: Array of points for drawing a closed shape. The size of enclosing rectangle is 100 by 100.

  - parameter factor: The factor by which the star points are scaled. For example, if it is 0.5 the output points will define the shape twice as small as the original.

  - returns: The scaled shape.

  */
  static func scaleStar(_ starPoints: [CGPoint], factor: Double, lineWidth: Double) -> [CGPoint] {
    return starPoints.map { point in
      return CGPoint(
        x: point.x * CGFloat(factor) + CGFloat(lineWidth),
        y: point.y * CGFloat(factor) + CGFloat(lineWidth)
      )
    }
  }
}
