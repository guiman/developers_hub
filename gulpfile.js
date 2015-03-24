var gulp = require('gulp'),
    run = require('gulp-run'),
    browserify = require('browserify'),
    concat = require('gulp-concat'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer'),
    reactify = require('reactify');

gulp.task('js', function() {
  return browserify('./assets/javascripts/app.js')
  .transform(reactify)
  .bundle()
  .pipe(source('.'))
  .pipe(gulp.dest('public/javascripts/app.js'));
});
