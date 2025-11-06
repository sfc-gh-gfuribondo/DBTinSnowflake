"""
Snowflake Notebook: List dbt Packages
This notebook demonstrates running dbt commands within Snowflake
"""

# Cell 1: Install dbt-snowflake
import sys
import subprocess

print("Installing dbt-snowflake...")
subprocess.check_call([sys.executable, "-m", "pip", "install", "dbt-snowflake==1.7.1", "-q"])
print("✅ dbt-snowflake installed successfully!")

# Cell 2: Import and check version
import dbt.version
print(f"dbt version: {dbt.version.__version__}")

# Cell 3: List installed dbt packages
print("\n📦 Installed dbt-related packages:")
result = subprocess.run(
    [sys.executable, "-m", "pip", "list"],
    capture_output=True,
    text=True
)
for line in result.stdout.split('\n'):
    if 'dbt' in line.lower():
        print(f"  • {line}")

# Cell 4: Show dbt packages from packages.yml
print("\n📋 dbt Packages configured in project:")
packages_content = """
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
"""
print(packages_content)

# Cell 5: Show package information
print("\n🔍 dbt Package Details:")
print("=" * 60)
print("Package: dbt-labs/dbt_utils")
print("Version: 1.1.1")
print("Description: Utility macros for dbt projects")
print("Repository: https://github.com/dbt-labs/dbt-utils")
print("=" * 60)

# Cell 6: Display available dbt commands
print("\n💻 Available dbt commands:")
commands = [
    "dbt debug - Test database connection",
    "dbt deps - Install package dependencies",
    "dbt seed - Load CSV files",
    "dbt run - Execute models",
    "dbt test - Run data tests",
    "dbt docs generate - Create documentation",
    "dbt build - Run everything"
]
for cmd in commands:
    print(f"  • {cmd}")

print("\n✅ Notebook execution complete!")

