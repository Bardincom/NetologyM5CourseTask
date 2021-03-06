// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Localization {

  public enum Button {
    /// Follow
    public static let follow = Localization.tr("Localizable", "Button.Follow")
    /// OK
    public static let ok = Localization.tr("Localizable", "Button.OK")
    /// Sign In
    public static let signIn = Localization.tr("Localizable", "Button.SignIn")
    /// Unfollow
    public static let unfollow = Localization.tr("Localizable", "Button.Unfollow")
  }

  public enum Controller {
    /// Add Post
    public static let addPost = Localization.tr("Localizable", "Controller.Add Post")
    /// Feed
    public static let feed = Localization.tr("Localizable", "Controller.Feed")
    /// Profile
    public static let profile = Localization.tr("Localizable", "Controller.Profile")
  }

  public enum Error {
    /// Bad request
    public static let badRequest = Localization.tr("Localizable", "Error.Bad request")
    /// Not acceptable
    public static let notAcceptable = Localization.tr("Localizable", "Error.Not acceptable")
    /// Not found
    public static let notFound = Localization.tr("Localizable", "Error.Not found")
    /// Offline mode
    public static let offlineMode = Localization.tr("Localizable", "Error.Offline mode")
    /// Unauthorized
    public static let unauthorized = Localization.tr("Localizable", "Error.Unauthorized")
    /// Unprocessable
    public static let unprocessable = Localization.tr("Localizable", "Error.Unprocessable")
  }

  public enum Filter {
    /// BoxBlur
    public static let boxBlur = Localization.tr("Localizable", "Filter.BoxBlur")
    /// ColorInvert
    public static let colorInvert = Localization.tr("Localizable", "Filter.ColorInvert")
    /// Noir
    public static let noir = Localization.tr("Localizable", "Filter.Noir")
    /// Normal
    public static let normal = Localization.tr("Localizable", "Filter.Normal")
    /// Pixellate
    public static let pixellate = Localization.tr("Localizable", "Filter.Pixellate")
    /// Sepia
    public static let sepia = Localization.tr("Localizable", "Filter.Sepia")
    /// SpotColor
    public static let spotColor = Localization.tr("Localizable", "Filter.SpotColor")
    /// Tonal
    public static let tonal = Localization.tr("Localizable", "Filter.Tonal")
  }

  public enum Names {
    /// Description
    public static let description = Localization.tr("Localizable", "Names.Description")
    /// Instagram
    public static let feedTitle = Localization.tr("Localizable", "Names.FeedTitle")
    /// Filters
    public static let filters = Localization.tr("Localizable", "Names.Filters")
    /// Followers
    public static let followers = Localization.tr("Localizable", "Names.Followers")
    /// Following
    public static let following = Localization.tr("Localizable", "Names.Following")
    /// Likes
    public static let likes = Localization.tr("Localizable", "Names.Likes")
    /// New Post
    public static let newPost = Localization.tr("Localizable", "Names.New Post")
  }

  public enum Placeholder {
    /// Enter you description
    public static let description = Localization.tr("Localizable", "Placeholder.Description")
    /// Login
    public static let login = Localization.tr("Localizable", "Placeholder.Login")
    /// Password
    public static let password = Localization.tr("Localizable", "Placeholder.Password")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
