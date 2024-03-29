const { src, dest, watch, series, parallel } = require('gulp');
const sass = require('gulp-dart-sass');
const sourcemaps = require('gulp-sourcemaps');
const autoprefixer = require('gulp-autoprefixer');
const cleanCss = require('gulp-clean-css');
const rename = require('gulp-rename');
const coffee = require('gulp-coffee');
const include = require('gulp-include');
const terser = require('gulp-terser');
const replace = require('gulp-replace');
const browserSync = require('browser-sync').create();
const clean = require('gulp-clean');
const fs = require('fs');

const packageInfo = require('./package.json');

sass.compiler = require('node-sass');

/**********************************************************
1. dodać browserReload ✓
2. dodać default task ✓
3. dodać funkcję build ✓
4. dodać zadanie Cache Bust ✓
5. zamienić uglyfly na terser ✓
	[https://www.npmjs.com/package/terser]
6. zamienić gulp-sourcemaps na opcję wbudowaną
	[https://gulpjs.com/docs/en/api/src#sourcemaps]
7. Usunąć stare pliki z dist przed skopiowaniem plików
**********************************************************/

let path = {
	sass: './src/scss/',
	css: './src/css/',
	coffee: './src/coffee/',
	js: './src/js/',
	src: './src/',
	dist: './dist/'
};
const filesToMove = [
	path.src + 'ajax/**/*.json',
	path.src + 'assets/**/*',
	path.css + 'main.min.css',
	path.css + 'main.min.css.map',
	path.js + 'scripts.min.js',
	path.js + 'scripts.min.js.map',
	path.src + 'images/**/*',
	'./src/index.html',
	path.src + '*.png',
	path.src + 'site.webmanifest'
];

function scss() {
	return src(path.sass + 'main.scss')
		.pipe(sourcemaps.init())
		.pipe(sass().on('error', sass.logError))
		.pipe(autoprefixer())
		.pipe(sourcemaps.write('./'))
		.pipe(dest(path.css));
}

function css() {
	return src('./src/css/main.css')
		.pipe(sourcemaps.init())
		.pipe(cleanCss())
		.pipe(rename({
			suffix: '.min'
		}))
		.pipe(sourcemaps.write('./'))
		.pipe(dest(path.css))
		.pipe(browserSync.reload({stream: true}));
}

function coffeeScript() {
	return src(path.coffee + 'main.coffee')
		.pipe(sourcemaps.init())
		.pipe(coffee().on('error', console.log))
		.pipe(sourcemaps.write('./'))
		.pipe(dest(path.js + 'components'));
}

function js() {
	return src(path.js + 'components.js')
		.pipe(sourcemaps.init())
		.pipe(include().on('error', console.log))
		.pipe(terser())
		.pipe(rename('scripts.min.js'))
		.pipe(sourcemaps.write('./'))
		.pipe(dest(path.js))
		.pipe(browserSync.reload({stream: true}));
}

function cacheBust() {
	console.log(`Wersja strony ${packageInfo.version},\n${packageInfo.versionMessage}`);
	return src(path.src + 'index.html')
		.pipe(replace(/v=[\d+\.*]+/g, 'v=' + packageInfo.version))
		.pipe(dest(path.src));
}

function serve(cb) {
	browserSync.init({
		server: {
			baseDir: path.src
		}
	});
	watch(path.src + 'index.html').on('change', browserSync.reload);
	cb();
}

function defaultTask(cb) {
	console.log(`
		* * * * * * * * * * * * * * * * * *
		*                                 *
		*   Please use npm run scripts    *
		*                                 *
		* * * * * * * * * * * * * * * * * *`
	);
	cb();
}

function bigBrother() {
	console.log('Watching…');
	watch('./src/scss/**/*.scss', series(scss, css));
	watch('./src/coffee/**/*.coffee', series(coffeeScript, js));
}

function moveFiles() {
	return src(filesToMove, { base: './src/'})
		.pipe(dest(path.dist))
}

function cleanDist(cb) {
	fs.access(path.dist, (err) => {
		if (err) {
			console.log(err);
			cb();
		} else {
			src(path.dist, {read: false})
			.pipe(clean());
			cb();
		}
	})
}

exports.cleanDist = cleanDist;

exports.default = defaultTask;
exports.cacheBust = cacheBust;
exports.serve = serve;
exports.moveFiles = moveFiles;
exports.dev = series(
	parallel(
		series(scss, css),
		series(coffeeScript, js)
	),
	serve,
	bigBrother
);
exports.build = series(
	cleanDist,
	parallel(
		series(scss, css),
		series(coffeeScript, js)
	),
	cacheBust,
	moveFiles
);
