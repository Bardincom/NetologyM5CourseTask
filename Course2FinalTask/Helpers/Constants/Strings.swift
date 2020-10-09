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
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
