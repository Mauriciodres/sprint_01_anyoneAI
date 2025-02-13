from typing import Dict

from pandas import DataFrame
from sqlalchemy.engine.base import Engine


def load(data_frames: Dict[str, DataFrame], database: Engine):

   for table_name, df in data_frames.items():
        # Utilizar pandas.DataFrame.to_sql() para cargar el DataFrame en la base de datos
        df.to_sql(name=table_name, con=database, index=False, if_exists='replace')
        print(f"Done table {table_name}")

