import random
import logging.config
import logging
import pandas as pd
from src import project_dir
from glob import glob


__all__ = [
    'logging_cfg', 'get_area_lut'
]

logger = logging.getLogger(__name__)


def logging_cfg(args):
    """Configure logging for entire project"""
    logging.config.fileConfig(
        f'{project_dir}/logging.conf',
        disable_existing_loggers=False,
        defaults={
            'main_log_filename': f'{project_dir}/logs/{args.dataset}_out.log',
            'all_log_filename': f'{args.results_dir}/out.log',
            'console_level': 'DEBUG' if args.verbose else 'INFO'
        }
    )


def get_area_lut(area_record_file, filter_by_input_bits=None):
    area_files = glob(area_record_file)
    area_file = [file for file in area_files if '50ms' in file]
    area_file = random.sample(area_files) if not area_file else area_file[0]

    area_df = pd.read_csv(area_file, sep='\t')
    if filter_by_input_bits:
        area_df = area_df.loc[area_df['InputBits'] == filter_by_input_bits]

    area_lut = {}
    for inp_bits in area_df['InputBits'].unique():
        area_lut[inp_bits] = {}
        constants_for_inp_bits = area_df.loc[area_df['InputBits'] == inp_bits]['Constant']
        for constant in constants_for_inp_bits:
            area_lut[inp_bits][constant] = area_df.loc[
                (area_df['InputBits'] == inp_bits) & (area_df['Constant'] == constant)
            ]['Area'].iloc[0]

    return area_lut
