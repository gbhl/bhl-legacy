package at.co.ait.domain.services;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public abstract class ProcessbuilderService {
	// can run basic ls or ps commands
	// can run command pipelines
	// can run sudo command if you know the password is correct
	
	int result;
	String stdout;
	String stderr;

	public int getResult() {
		return result;
	}

	public String getStdout() {
		return stdout;
	}

	public String getStderr() {
		return stderr;
	}

	public void process(List<String> commands) throws IOException, InterruptedException {
		// execute the command
		SystemCommandExecutor commandExecutor = new SystemCommandExecutor(
				commands);
		result = commandExecutor.executeCommand();

		// get the stdout and stderr from the command that was run
		stdout = commandExecutor.getStandardOutputFromCommand();
		stderr = commandExecutor.getStandardErrorFromCommand();
	}
}
