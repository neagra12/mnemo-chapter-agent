"""
This is a placeholder test file for the MoJ starter kit.

Its only purpose is to give pytest something to find and run successfully,
so that our initial CI pipeline (from ICE 2) can pass.
"""

def test_ci_pipeline_is_working():
    """
    A simple test that always passes.
    If this test runs, it proves that:
    1. The self-hosted runner is active.
    2. The main.yml workflow file is syntactically correct.
    3. `pytest` was correctly installed and executed.
    """
    print("CI pipeline placeholder test executed successfully.")
    assert True