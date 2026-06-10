/// This is a port from Nova to GS13!
import type { Feature } from '../../base';
import { FeatureColorInput, FeatureNumberInput } from '../../base';

export const cosglow_glow_color: Feature<string> = {
  name: 'Color',
  component: FeatureColorInput,
};

export const cosglow_thickness: Feature<number> = {
  name: 'Thickness',
  component: FeatureNumberInput,
};
