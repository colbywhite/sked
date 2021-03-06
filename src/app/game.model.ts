export interface WinLossMetric {
  Losses: number;
  Wins: number;
  WinPct: number;
  score: number;
}

export interface LastSeasonMetric {
  score: number;
}

export interface OffenseMetric {
  score: number;
  PtsPerGame: number;
}

export interface PointDifferenceMetric {
  score: number;
  PtsPerGame: number;
  PtsAgainstPerGame: number;
  PtsDiffPerGame: number;
}

export interface Team {
  abbreviated_name: string;
  full_name: string;
  short_name: string;
  score: number;
  metrics: {
    win_loss: WinLossMetric;
    last_season: LastSeasonMetric;
    offense: OffenseMetric;
    pt_diff: PointDifferenceMetric;
  };
}

export interface Game {
  home: Team;
  away: Team;
  time: string;
  score: string;
}

export interface Schedule {
  [key: string]: Game[];
}

export interface ColumnedSchedule {
  [key: string]: Game[][];
}

export class ScheduleSplitter {
  public static splitScheduleIntoColumns = (data: [Schedule, number]): ColumnedSchedule => {
    const [schedule, numColumns] = data;
    return Object.entries(schedule)
      .map((entry: [string, Game[]]) => {
        const [date, games] = entry;
        const columns: Game[][] = ScheduleSplitter.splitIntoSubArrays<Game>(games, numColumns);
        return [date, columns] as [string, Game[][]];
      }).reduce((result: ColumnedSchedule, entry: [string, Game[][]]) => {
        const [date, columns] = entry;
        result[date] = columns;
        return result;
      }, {} as ColumnedSchedule);
  }

  private static splitIntoSubArrays<T>(arr: T[], numColumns: number): T[][] {
    // make an array from 0..N-1
    return Array.from(Array(numColumns).keys())
    // get a sub array with the values at the corresponding indexes
      .map((remainder) => arr.filter((val, index) => index % numColumns === remainder));
  }
}
