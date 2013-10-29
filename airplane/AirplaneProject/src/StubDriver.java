
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.DoubleWritable;


public class StubDriver extends Configured implements Tool {

  public static void main(String[] args) throws Exception {

	  	StubDriver driver = new StubDriver();
		int exitCode = ToolRunner.run(driver, args);
		System.exit(exitCode);
	  
  }

  @Override
  public int run(String[] args) throws Exception {
	  
		String input, output;
		if (args.length == 2) {
			input = args[0];
			output = args[1];
		} else {
			System.err.println("Incorrect number of arguments.  Expected: input output");
			return -1;
		}

    /*
     * Instantiate a Job object for your job's configuration. 
     */
    Job job = new Job();
    
    job.setJarByClass(StubDriver.class);

    job.setJobName("Stub Driver");

    FileInputFormat.setInputPaths(job, new Path(input));
	FileOutputFormat.setOutputPath(job, new Path(output));

	job.setMapperClass(StubMapper.class);
	job.setReducerClass(StubReducer.class);
    
	job.setMapOutputKeyClass(Text.class);
	job.setMapOutputValueClass(IntWritable.class);

	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(DoubleWritable.class);
    
    /*
     * Start the MapReduce job and wait for it to finish.
     * If it finishes successfully, return 0. If not, return 1.
     */
    boolean success = job.waitForCompletion(true);
    return success ? 0 : 1;
  }
}

