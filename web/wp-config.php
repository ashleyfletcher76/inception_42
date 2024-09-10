<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'Ntv!2j/!8iNjNguB;uOxu{BlUw.w(7OGso@!Nt!,?L_sjGAhH+(X_cYM*~xLk?py' );
define( 'SECURE_AUTH_KEY',   'Dcm,mf;SvNI219mA!Ve|]G,m*8gE)-&~Bbu7(VN.N{%NlU]HE3x5x,oEOg~P@L3@' );
define( 'LOGGED_IN_KEY',     'wRUg wDQy3|:=3A]Afpin!A(*|s8C4gHbc5ds@h{]01$wXKgY<-R[l!khn#(E|<g' );
define( 'NONCE_KEY',         'q5YcT${3;}_:f}yBQ.K}loKd #jmQO`een!f$%AUI]tU`En;[T BoZD?/GC5&iQz' );
define( 'AUTH_SALT',         '1n;(sFJ&bW<q|7UD^dWGTQdn4HQiR5,3THDEz.=^+WU(jkeZ7*j*:074_uHL2;*O' );
define( 'SECURE_AUTH_SALT',  'IG MBtrY[QmA()>Z?$4moObPA-idW$ty>UfpjV-rYa#e|X}{}snHkXh,_>[9.`Gn' );
define( 'LOGGED_IN_SALT',    '}|)}4VHEtdo=$4vUVbN7}[=+VTv1[:t1+$[!/x`zN>U9/Q(lQY -_U/7Bm)xumdM' );
define( 'NONCE_SALT',        '>+xCHZT^( +(=$c#Zt.y8y!#mgyDw]xo6gwp]A#^]i!<<w-t]mD];xi}*C0`9e}=' );
define( 'WP_CACHE_KEY_SALT', ':I;^q~HCcbu&Q5fkl#25R!)QRd>Du)o?.TiwdF-mmBjY>XW(L|acc=<[NaWycK(O' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
