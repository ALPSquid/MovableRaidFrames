import os
import shutil
import zipfile


addon_name = "MovableRaidFrames"
addon_root_folder = "MovableRaidFrames"
builds_folder = "Builds"
extra_archive_files = ["CHANGELOG.md", "LICENSE.txt"]

version_num = 0

with open(os.path.join(addon_root_folder, "MovableRaidFrames.toc"), 'r') as toc_file:
    for line in toc_file:
        if "## Version:" in line:
            version_num = line.split()[2]

print("Building version " + version_num)

release_folder = os.path.join(builds_folder, version_num)
release_zip_path = os.path.join(release_folder, addon_name + "_" + version_num)

if not os.path.exists("Builds"):
    os.mkdir("Builds")

if os.path.isfile(release_zip_path):
    os.rm(release_zip_path)
    
shutil.make_archive(release_zip_path, "zip", os.path.join(addon_root_folder, os.pardir), addon_root_folder)
# Add changelog and license
archive_file = zipfile.ZipFile(release_zip_path+".zip", 'a')
for extra_file in extra_archive_files:
    archive_file.write(extra_file, os.path.join(addon_root_folder, os.path.basename(extra_file)))
archive_file.close()
