# A small helper class that returns a collection of available migration classes
class MigrationLoader
  def self.migrations(path)
    Dir[path].map do |migration|
      load migration

      # Getting the class name like part of the path
      migration_time, migration_file_name = migration.match(/\/([0-9]*)_([a-z_]*).rb$/).captures
      # And then turn that into AClassNameLikeThis
      migration_class = Object.const_get(migration_file_name.split('_').map(&:capitalize).join)

      [migration_time, migration_class]
    end
  end
end
