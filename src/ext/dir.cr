# -----------------------------------------------------------------------
# This file is part of MoonScript
#
# MoonSript is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MoonSript is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MoonSript.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2025 Krisna Pranav, MoonScript Developers
# -----------------------------------------------------------------------

class Dir
  def self.safe_delete(directory, &)
    return unless Dir.exists?(directory)
    yield
    FileUtils.rm_rf(directory)
  end

  def self.tempdir(&)
    path =
      Path[tempdir, Random::Secure.hex]

    begin
      FileUtils.mkdir_p(path)
      FileUtils.cd(path) { yield }
    ensure
      FileUtils.rm_rf(path)
    end
  end
end
